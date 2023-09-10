import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tv/utils/utils.dart';
import 'package:tv/models/extensions.dart';
import 'package:tv/manger/Section.dart';
import 'package:tv/manger/status.dart';
import 'package:tv/models/favoriteModel.dart';
import 'package:tv/models/user-model.dart';
import 'package:tv/manger/user-type.dart';
import 'package:tv/models/user_profile.dart';
import 'package:tv/models/channelModel.dart';
import 'package:tv/models/SectionModel.dart';
import '../models/lang.dart';
import '../models/loader.dart';
import '../models/notification-model.dart';

class FirebaseManager {
  static final FirebaseManager shared = FirebaseManager();
  final FirebaseAuth auth = FirebaseAuth.instance;
  final userRef = FirebaseFirestore.instance.collection('User');
  final sectionRef = FirebaseFirestore.instance.collection('section');
  final channelRef = FirebaseFirestore.instance.collection('channel');
  final notificationRef = FirebaseFirestore.instance.collection('Notification');
  final favoriteRef = FirebaseFirestore.instance.collection('Favorite');

  // #:- Start User

  Stream<List<UserModel>> getAllUsers() {
    // ignore: non_constant_identifier_names, avoid_types_as_parameter_names
    return userRef.snapshots().map((QueryDocumentSnapshot) {
      return QueryDocumentSnapshot.docs.map((doc) {
        return UserModel.fromJson(doc.data());
      }).toList();
    });
  }

  Future<UserModel> getUserByUid({required String uid}) async {
    UserModel userTemp;

    if (!isFirebaseDown) {
      var user = await userRef.doc(uid).snapshots().first;
      userTemp = UserModel.fromJson(user.data());
    } else {
      userTemp = UserModel(
          name: "admin",
          uid: userIdAdmin(),
          userType: UserType.ADMIN,
          accountStatus: Status.ACTIVE,
          email: "shaovapan@hotmail.com",
          city: "bkk");
    }
    return userTemp;
  }

  Future<UserModel> getCurrentUser() {
    if (!isFirebaseDown) {
      return getUserByUid(uid: auth.currentUser!.uid);
    } else {
      return getUserByUid(uid: "xxx");
    }
  }

  createAccountUser({
    required GlobalKey<ScaffoldState> scaffoldKey,
    required String name,
    required String phone,
    required String email,
    required String city,
    required String password,
  }) async {
    showLoaderDialog(scaffoldKey.currentContext);
    // print("email is invalid? ");
    if (!email.isValidEmail()) {
      scaffoldKey.showTosta(
          message: AppLocalization.of(scaffoldKey.currentContext!)!
              .trans("please enter a valid email"),
          isError: true);
      showLoaderDialog(scaffoldKey.currentContext, isShowLoader: false);
      return;
    }

    // print("email is correct. 1 ");
    var userId = await _createAccountInFirebase(
        scaffoldKey: scaffoldKey, email: email, password: password);

    // print("email is correct. 2 ");
    if (userId != null) {
      // print("email is correct. 3");
      userRef.doc(userId).set({
        "id": "${Random().nextInt(99999)}",
        "name": name,
        "phone": phone,
        "email": email,
        "city": city,
        "createdDate": DateTime.now().toString(),
        "status-account": 1,
        "type-user": 1,
        "uid": userId,
      }).then((value) async {
        showLoaderDialog(scaffoldKey.currentContext, isShowLoader: false);
        addNotifications(
            uidUser: userId,
            titleEN: "Welcome",
            titleAR: "مرحبا بك",
            detailsEN: "Welcome to our app\nWe wish you a happy experience",
            detailsAR: "مرحبا بك في تطبيقنا\nنتمنى لك تجربة رائعة");

        await getAllUsers().first.then((users) {
          for (var user in users) {
            if (user.userType == UserType.ADMIN) {
              addNotifications(
                  uidUser: user.uid!,
                  titleEN: "New User",
                  titleAR: "مستخدم جديد",
                  detailsEN: "$name new created a new account",
                  detailsAR: "$name أنشأ حساب جديد ");
            }
          }
        });

        Navigator.of(scaffoldKey.currentContext!).pushNamedAndRemoveUntil(
            "/SignIn", (route) => false,
            arguments:
                "Account created successfully, Your account in now under review");
      }).catchError((err) {
        showLoaderDialog(scaffoldKey.currentContext, isShowLoader: false);
        scaffoldKey.showTosta(
            message: AppLocalization.of(scaffoldKey.currentContext!)!
                .trans("Something went wrong"),
            isError: true);
      });
    } else {
      showLoaderDialog(scaffoldKey.currentContext, isShowLoader: false);
    }
  }

  changeStatusAccount({
    required GlobalKey<ScaffoldState> scaffoldKey,
    required String userId,
    required Status status,
  }) {
    showLoaderDialog(scaffoldKey.currentContext);
    userRef.doc(userId).update({
      "status-account": status.index,
    }).then((value) async {
      showLoaderDialog(scaffoldKey.currentContext, isShowLoader: false);
      scaffoldKey.showTosta(
          message: AppLocalization.of(scaffoldKey.currentContext!)!
              .trans("done successfully"));
    }).catchError((err) {
      showLoaderDialog(scaffoldKey.currentContext, isShowLoader: false);
      scaffoldKey.showTosta(
          message: AppLocalization.of(scaffoldKey.currentContext!)!
              .trans("Something went wrong"),
          isError: true);
    });
  }

  updateAccount({
    required GlobalKey<ScaffoldState> scaffoldKey,
    required String name,
    required String city,
    required String phoneNumber,
  }) async {
    showLoaderDialog(scaffoldKey.currentContext);

    userRef.doc(auth.currentUser!.uid).update({
      "name": name,
      "phone": phoneNumber,
      "city": city,
    }).then((value) async {
      showLoaderDialog(scaffoldKey.currentContext, isShowLoader: false);
      UserModel? user = (await UserProfile.shared.getUser());
      user!.name = name;
      user.city = city;
      user.phone = phoneNumber;
      UserProfile.shared.setUser(user: user);
      Navigator.of(scaffoldKey.currentContext!).pop();
    }).catchError((err) {
      showLoaderDialog(scaffoldKey.currentContext, isShowLoader: false);
      scaffoldKey.showTosta(
          message: AppLocalization.of(scaffoldKey.currentContext!)!
              .trans("Something went wrong"),
          isError: true);
    });
  }

  changePassword({
    required GlobalKey<ScaffoldState> scaffoldKey,
    required String newPassword,
    required String confirmPassword,
  }) async {
    showLoaderDialog(scaffoldKey.currentContext);
    auth.currentUser!.updatePassword(newPassword).then((value) {
      showLoaderDialog(scaffoldKey.currentContext, isShowLoader: false);
      Navigator.of(scaffoldKey.currentContext!).pop();
    }).catchError((err) {
      showLoaderDialog(scaffoldKey.currentContext, isShowLoader: false);
      scaffoldKey.showTosta(
          message: AppLocalization.of(scaffoldKey.currentContext!)!
              .trans("Something went wrong"),
          isError: true);
    });
  }

  // #:- End User

  login(
      {required GlobalKey<ScaffoldState> scaffoldKey,
      required String email,
      required String password}) async {
    showLoaderDialog(scaffoldKey.currentContext);

    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      await getUserByUid(uid: auth.currentUser!.uid).then((UserModel user) {
        //print("what is user's status : " + user.accountStatus.toString());
        switch (user.accountStatus) {
          case Status.ACTIVE:
            showLoaderDialog(scaffoldKey.currentContext, isShowLoader: false);
            //print("Before set user ");
            UserProfile.shared.setUser(user: user);
            Navigator.of(scaffoldKey.currentContext!).pushNamedAndRemoveUntil(
                '/TabBarPage', (Route<dynamic> route) => false,
                arguments: user.userType);
            break;
          case Status.PENDING:
            showLoaderDialog(scaffoldKey.currentContext, isShowLoader: false);
            scaffoldKey.showTosta(
                message: AppLocalization.of(scaffoldKey.currentContext!)!
                    .trans("Account under review"),
                isError: true);
            auth.signOut();
            break;
          case Status.Rejected:
            showLoaderDialog(scaffoldKey.currentContext, isShowLoader: false);
            scaffoldKey.showTosta(
                message: AppLocalization.of(scaffoldKey.currentContext!)!
                    .trans("Your account has been denied"),
                isError: true);
            auth.signOut();
            break;
          case Status.Deleted:
            showLoaderDialog(scaffoldKey.currentContext, isShowLoader: false);
            scaffoldKey.showTosta(
                message: AppLocalization.of(scaffoldKey.currentContext!)!
                    .trans("Your account has been deleted"),
                isError: true);
            auth.signOut();
            break;
          case Status.Disable:
            showLoaderDialog(scaffoldKey.currentContext, isShowLoader: false);
            scaffoldKey.showTosta(
                message: AppLocalization.of(scaffoldKey.currentContext!)!
                    .trans("Your account has been disabled"),
                isError: true);
            auth.signOut();
            break;
          default:
            break;
        }
      });

      //print("3 email : " + email + ", password : " + password);

      return;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        scaffoldKey.showTosta(
            message: AppLocalization.of(scaffoldKey.currentContext!)!
                .trans("user not found"),
            isError: true);
      } else if (e.code == 'wrong-password') {
        scaffoldKey.showTosta(
            message: AppLocalization.of(scaffoldKey.currentContext!)!
                .trans("wrong password"),
            isError: true);
      } else if (e.code == 'too-many-requests') {
        scaffoldKey.showTosta(
            message: AppLocalization.of(scaffoldKey.currentContext!)!
                .trans("The account is temporarily locked"),
            isError: true);
      }

      showLoaderDialog(scaffoldKey.currentContext, isShowLoader: false);

      //print("4 email : " + email + ", password : " + password);
      //print(e);
    }

    showLoaderDialog(scaffoldKey.currentContext, isShowLoader: false);
    return;
  }

  Future<String?> _createAccountInFirebase(
      {required GlobalKey<ScaffoldState> scaffoldKey,
      required String email,
      required String password}) async {
    try {
      //print("_createAccountInFirebase is correct.1");
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      //print("_createAccountInFirebase is correct.2");
      return userCredential.user!.uid;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        //print("_createAccountInFirebase is correct.3.1");
        scaffoldKey.showTosta(
            message: AppLocalization.of(scaffoldKey.currentContext!)!
                .trans("the email is already used"),
            isError: true);
      }
      //print(e);
      //print("_createAccountInFirebase is correct.3.2");
      return null;
    } catch (e) {
      scaffoldKey.showTosta(
          message: AppLocalization.of(scaffoldKey.currentContext!)!
              .trans("something went wrong"),
          isError: true);
      //print(e);
      //print("_createAccountInFirebase is correct.4");
      return null;
    }
  }

  signOut(context) async {
    try {
      showLoaderDialog(context);
      await FirebaseAuth.instance.signOut();
      await UserProfile.shared.setUser(user: null);
      showLoaderDialog(context, isShowLoader: false);
      Navigator.pushNamedAndRemoveUntil(context, "/SignIn", (route) => false);
    } catch (_) {
      showLoaderDialog(context, isShowLoader: false);
    }
  }

  forgotPassword(
      {required GlobalKey<ScaffoldState> scaffoldKey,
      required String email}) async {
    showLoaderDialog(scaffoldKey.currentContext);
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: email,
      );
      showLoaderDialog(scaffoldKey.currentContext, isShowLoader: false);
      return true;
    } on FirebaseAuthException catch (e) {
      showLoaderDialog(scaffoldKey.currentContext, isShowLoader: false);
      if (e.code == 'user-not-found') {
        scaffoldKey.showTosta(
            message: AppLocalization.of(scaffoldKey.currentContext!)!
                .trans("user not found"),
            isError: true);
        return false;
      }
    }
  }

  deleteAccount(context, {required String iduser}) async {
    showLoaderDialog(context);

    await userRef.doc(iduser).delete().then((_) => {}).catchError((e) {});

    showLoaderDialog(context, isShowLoader: false);
  }

// #:- END auth
// #:- Start Notifications

  addNotifications({
    required String uidUser,
    required String titleEN,
    required String titleAR,
    required String detailsEN,
    required String detailsAR,
  }) async {
    String uid = notificationRef.doc().id;
    notificationRef
        .doc(uid)
        .set({
          "user-id": uidUser,
          "title-en": titleEN,
          "title-ar": titleAR,
          "details-en": detailsEN,
          "details-ar": detailsAR,
          "createdDate": DateTime.now().toString(),
          "is-read": false,
          "uid": uid,
        })
        .then((value) {})
        .catchError((err) {});
  }

  setNotificationRead() async {
    List<NotificationModel> items = await getMyNotifications().first;
    for (var item in items) {
      if (item.userId == auth.currentUser!.uid && !item.isRead) {
        notificationRef.doc(item.uid).update({
          "is-read": true,
        });
      }
    }
  }

  Stream<List<NotificationModel>> getMyNotifications() {
    return notificationRef
        .where("user-id",
            isEqualTo:
                (auth.currentUser == null ? "xxx" : auth.currentUser!.uid))
        .snapshots()
        // ignore: avoid_types_as_parameter_names, non_constant_identifier_names
        .map((QueryDocumentSnapshot) {
      return QueryDocumentSnapshot.docs.map((doc) {
        return NotificationModel.fromJson(doc.data());
      }).toList();
    });
  }

// #:- End Notifications
// #:- Start section

  Future<String> section(
    context, {
    String uid = "",
    required GlobalKey<ScaffoldState> scaffoldKey,
    required String titleEN,
    required String titleAR,
    required Section section,
    required String createDt,
    required String updateDt,
  }) async {
    showLoaderDialog(context);
    String tempUid = (uid == "") ? sectionRef.doc().id : uid;
    String existsId = "";
    if (uid == "") {
      await sectionRef
          .where("title-en", isEqualTo: titleEN)
          .get()
          // ignore: avoid_function_literals_in_foreach_calls
          .then((value) => value.docs.forEach((document) {
                existsId = document.id;
              }));
      // print("existsId uid 2 is " + existsId);
      if (existsId != "") {
        // print("Found duplicated section name : " + titleEN);
        showLoaderDialog(context, isShowLoader: false);
        return existsId;
      }
    }
    await sectionRef.doc(tempUid).set({
      "title-en": titleEN,
      "title-ar": titleAR,
      "section": section.index,
      "uid": tempUid,
      "createDt": createDt,
      "updateDt": updateDt,
    }).then((value) {
      showLoaderDialog(context, isShowLoader: false);
      // Navigator.of(context).pop();
      // print("Now get tempUid is " + tempUid);
    }).catchError((err) {
      showLoaderDialog(context, isShowLoader: false);
    });

    return tempUid;
  }

  deleteSection(context, {required String uidSection}) async {
    showLoaderDialog(context);

    await sectionRef
        .doc(uidSection)
        .delete()
        .then((_) => {})
        .catchError((e) {});

    // await channelRef
    //     .doc(uidchannel)
    //     .delete()
    //     .then((_) => {})
    //     .catchError((e) {});

    await channelRef
        .where("section-uid", isEqualTo: uidSection)
        .get()
        // ignore: avoid_function_literals_in_foreach_calls
        .then((value) => value.docs.forEach((document) {
              channelRef.doc(document.id).delete().then((_) {
                //print("success!");

                favoriteRef
                    .where("channelId", isEqualTo: document.id)
                    .get()
                    // ignore: avoid_function_literals_in_foreach_calls
                    .then((value) => value.docs.forEach((document) {
                          favoriteRef.doc(document.id).delete().then((_) {
                            // print("success!");
                          });
                        }));
              });
            }));

    showLoaderDialog(context, isShowLoader: false);
  }

  Stream<List<SectionModel>> getSectionsByName(
      {required String sectionName, required String fieldType}) {
    return sectionRef
        .where(fieldType,
            isGreaterThanOrEqualTo: sectionName, isLessThan: sectionName + 'z')
        .snapshots()
        // ignore: non_constant_identifier_names, avoid_types_as_parameter_names
        .map((QueryDocumentSnapshot) {
      return QueryDocumentSnapshot.docs.map((doc) {
        return SectionModel.fromJson(doc.data());
      }).toList();
    });
  }

//   Future<List<SectionModel>> _getEventsFromFirestore() async {
// // CollectionReference ref = Firestore.instance.collection('events');
//     QuerySnapshot eventsQuery = await sectionRef
//         // .where("time", isGreaterThan: new DateTime.now().millisecondsSinceEpoch)
//         .where("food", isEqualTo: true)
//         .getDocuments();

// // HashMap<String, AustinFeedsMeEvent> eventsHashMap = new HashMap<String, AustinFeedsMeEvent>();

// // eventsQuery.documents.forEach((document) {
// //   eventsHashMap.putIfAbsent(document['id'], () => new SectionModel(
// //       name: document['name'],
// //       time: document['time'],
// //       description: document['description'],
// //       url: document['event_url'],
// //       photoUrl: _getEventPhotoUrl(document['group']),
// //       latLng: _getLatLng(document)));
// // });

// // return eventsHashMap.values.toList();
//     return null;
//   }

  Stream<List<SectionModel>> getSection({required Section section}) {
    return sectionRef
        .where("section", isEqualTo: section.index)
        // .orderBy("title-en", descending: false)
        .snapshots()
        // ignore: non_constant_identifier_names, avoid_types_as_parameter_names
        .map((QueryDocumentSnapshot) {
      return QueryDocumentSnapshot.docs.map((doc) {
        return SectionModel.fromJson(doc.data());
      }).toList();
    });
  }

  Stream<List<SectionModel>> getSectionBySectionType(int sectionType) {
    return sectionRef
        .where("section", isEqualTo: sectionType)
        // .orderBy("title-en", descending: false)
        .snapshots()
        // ignore: non_constant_identifier_names, avoid_types_as_parameter_names
        .map((QueryDocumentSnapshot) {
      return QueryDocumentSnapshot.docs.map((doc) {
        return SectionModel.fromJson(doc.data());
      }).toList();
    });
  }

  Stream<List<SectionModel>> getMySection() {
    return sectionRef
        .where("uid-owner", isEqualTo: auth.currentUser!.uid)
        .snapshots()
        // ignore: avoid_types_as_parameter_names, non_constant_identifier_names
        .map((QueryDocumentSnapshot) {
      return QueryDocumentSnapshot.docs.map((doc) {
        return SectionModel.fromJson(doc.data());
      }).toList();
    });
  }

  Stream<List<SectionModel>> getAllSection() {
    // ignore: avoid_types_as_parameter_names, non_constant_identifier_names
    return sectionRef.snapshots().map((QueryDocumentSnapshot) {
      return QueryDocumentSnapshot.docs.map((doc) {
        return SectionModel.fromJson(doc.data());
      }).toList();
    });
  }

  Stream<SectionModel> getSectionById({required String id}) {
    // ignore: avoid_types_as_parameter_names, non_constant_identifier_names
    return sectionRef.doc(id).snapshots().map((QueryDocumentSnapshot) {
      return SectionModel.fromJson(QueryDocumentSnapshot.data());
    });
  }

  //  #:- End Section

  // #:- Start favorite

  addToFavorite(
    context, {
    required String channelId,
    required int section,
    required ChannelModel channel,
  }) async {
    showLoaderDialog(context);
    String tempUid = favoriteRef.doc().id;
    favoriteRef.doc(tempUid).set({
      "uid": tempUid,
      "userId": auth.currentUser!.uid,
      "channelId": channelId,
      "section": section,
      "sectionUid": channel.sectionuid,
      "streamURL": channel.streamURL,
      "logoURL": channel.logoURL,
      "titlear": channel.titleAR,
      "titleen": channel.titleEN,
    }).then((value) {
      showLoaderDialog(context, isShowLoader: false);
    }).catchError((err) {
      showLoaderDialog(context, isShowLoader: false);
    });
  }

  deleteFavoriteChannel(context, {required String uid}) async {
    showLoaderDialog(context);

    await favoriteRef.doc(uid).delete().then((_) => {}).catchError((e) {});

    showLoaderDialog(context, isShowLoader: false);
  }

  Stream<List<FavoriteModel>> getMyFavorites({required int section}) {
    return favoriteRef
        .where("userId", isEqualTo: auth.currentUser!.uid)
        .where("section", isEqualTo: section)
        .snapshots()
        // ignore: non_constant_identifier_names, avoid_types_as_parameter_names
        .map((QueryDocumentSnapshot) {
      return QueryDocumentSnapshot.docs.map((doc) {
        return FavoriteModel.fromJson(doc.data());
      }).toList();
    });
  }

  Stream<List<FavoriteModel>> getMyFavoritesBySectionUid(
      {required String sectionUid}) {
    return favoriteRef
        .where("userId", isEqualTo: auth.currentUser!.uid)
        .where("sectionUid", isEqualTo: sectionUid)
        .snapshots()
        // ignore: non_constant_identifier_names, avoid_types_as_parameter_names
        .map((QueryDocumentSnapshot) {
      return QueryDocumentSnapshot.docs.map((doc) {
        return FavoriteModel.fromJson(doc.data());
      }).toList();
    });
  }

  Stream<List<FavoriteModel>> getFavoriteByChannel(
      {required String channelId}) {
    return favoriteRef
        .where("userId", isEqualTo: auth.currentUser!.uid)
        .where("channelId", isEqualTo: channelId)
        .snapshots()
        // ignore: avoid_types_as_parameter_names, non_constant_identifier_names
        .map((QueryDocumentSnapshot) {
      return QueryDocumentSnapshot.docs.map((doc) {
        return FavoriteModel.fromJson(doc.data());
      }).toList();
    });
  }

  // #:- Start channel
  addOrEditChanne(
    context, {
    String uid = "",
    required GlobalKey<ScaffoldState> scaffoldKey,
    required String sectionuid,
    required String streamURL,
    required String titleEN,
    required String titleAR,
    required Section section,
    required String logoURL,
    required String createDt,
    required String updateDt,
  }) async {
    showLoaderDialog(context);

    String tempUid = (uid == "") ? channelRef.doc().id : uid;

    // print("what is logoUrl : " + logoURL);

    // if (uid == "") {
    //   await channelRef
    //       .where("streamURL", isEqualTo: streamURL)
    //       .where("section", isEqualTo: section.index)
    //       .get()
    //       // ignore: avoid_function_literals_in_foreach_calls
    //       .then((value) => value.docs.forEach((document) {
    //             existsId = document.id;
    //           }));
    //   if (existsId != "") {
    //     // print("Found duplicated channel name : " + titleEN);
    //     showLoaderDialog(context, isShowLoader: false);
    //     return;
    //   }
    // }
    await channelRef.doc(tempUid).set({
      "section-uid": sectionuid,
      "title-en": titleEN,
      "title-ar": titleAR,
      "streamURL": streamURL,
      "logoURL": logoURL,
      "section": section.index,
      "uid": tempUid,
      "createDt": createDt,
      "updateDt": updateDt,
    }).then((value) {
      showLoaderDialog(context, isShowLoader: false);
      // Navigator.of(context).pop();
    }).catchError((err) {
      showLoaderDialog(context, isShowLoader: false);
    });
  }

  deletechannel(context, {required String uidchannel}) async {
    showLoaderDialog(context);

    await channelRef
        .doc(uidchannel)
        .delete()
        .then((_) => {})
        .catchError((e) {});

    showLoaderDialog(context, isShowLoader: false);
  }

  Stream<List<ChannelModel>> getchannelByStatus({required String channel}) {
    return channelRef
        .where("section-uid", isEqualTo: channel)
        // .orderBy("title-en", descending: false)
        .snapshots()
        // ignore: avoid_types_as_parameter_names, non_constant_identifier_names
        .map((QueryDocumentSnapshot) {
      return QueryDocumentSnapshot.docs.map((doc) {
        return ChannelModel.fromJson(doc.data());
      }).toList();
    });
  }

  Stream<List<ChannelModel>> getchannelBySectionType(
      {required int sectionType}) {
    return channelRef
        .where("section", isEqualTo: sectionType)
        // .orderBy("title-en", descending: false)
        .snapshots()
        // ignore: avoid_types_as_parameter_names, non_constant_identifier_names
        .map((QueryDocumentSnapshot) {
      return QueryDocumentSnapshot.docs.map((doc) {
        return ChannelModel.fromJson(doc.data());
      }).toList();
    });
  }

  Stream<List<ChannelModel>> getchannelByName(
      {required String channelName, required String fieldType}) {
    return channelRef
        // .where(fieldType,
        //     isGreaterThanOrEqualTo: channelName, isLessThan: channelName + 'z')
        .snapshots()
        // ignore: avoid_types_as_parameter_names, non_constant_identifier_names
        .map((QueryDocumentSnapshot) {
      return QueryDocumentSnapshot.docs.map((doc) {
        return ChannelModel.fromJson(doc.data());
      }).toList();
    });
  }

  Stream<List<ChannelModel>> getAllchannel() {
    // ignore: avoid_types_as_parameter_names, non_constant_identifier_names
    return channelRef.snapshots().map((QueryDocumentSnapshot) {
      return QueryDocumentSnapshot.docs.map((doc) {
        return ChannelModel.fromJson(doc.data());
      }).toList();
    });
  }

  Stream<List<ChannelModel>> getMychannelTech() {
    return channelRef
        .where("owner-id", isEqualTo: auth.currentUser!.uid)
        .snapshots()
        // ignore: avoid_types_as_parameter_names, non_constant_identifier_names
        .map((QueryDocumentSnapshot) {
      return QueryDocumentSnapshot.docs.map((doc) {
        return ChannelModel.fromJson(doc.data());
      }).toList();
    });
  }

  Stream<List<ChannelModel>> getMychannel() {
    return channelRef
        .where("user-id", isEqualTo: auth.currentUser!.uid)
        .snapshots()
        // ignore: non_constant_identifier_names, avoid_types_as_parameter_names
        .map((QueryDocumentSnapshot) {
      return QueryDocumentSnapshot.docs.map((doc) {
        return ChannelModel.fromJson(doc.data());
      }).toList();
    });
  }

  Stream<ChannelModel> getchannelById({required String id}) {
    // ignore: non_constant_identifier_names, avoid_types_as_parameter_names
    return channelRef.doc(id).snapshots().map((QueryDocumentSnapshot) {
      return ChannelModel.fromJson(QueryDocumentSnapshot.data());
    });
  }

  // #:- ENd channel

}
