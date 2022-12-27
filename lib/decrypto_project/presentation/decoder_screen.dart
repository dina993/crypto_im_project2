import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dart_des/dart_des.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/encrypt_provider.dart';
import '../utilities/app_constants.dart';
import '../utilities/widgets.dart';

class DecoderPageView extends StatefulWidget {
  const DecoderPageView({Key? key}) : super(key: key);

  @override
  State<DecoderPageView> createState() => _DecoderPageViewState();
}

class _DecoderPageViewState extends State<DecoderPageView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                AssetsManger.lockImage,
                scale: 20,
              ),
              const SizedBox(
                width: AppConstants.s16,
              ),
              const Text(AppStrings.decoderTitle),
            ],
          ),
        ),
        body: Consumer<EncryptProvider>(builder: (context, provider, widget) {
          return SingleChildScrollView(
              child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.all(AppValues.m10),
                  padding: const EdgeInsets.all(AppValues.p15),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: const AssetImage(AssetsManger.backImage),
                      fit: BoxFit.fitHeight,
                      colorFilter: ColorFilter.mode(
                          Colors.black.withOpacity(AppConstants.imageOpacity),
                          BlendMode.dstATop),
                    ),
                  ),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppStrings.decryptTitle,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(
                          height: AppValues.p15,
                        ),
                        StreamBuilder<QuerySnapshot?>(
                            stream: FirebaseFirestore.instance
                                .collection('images')
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return Center(
                                  child: Text(
                                    'there is no orders',
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                );
                              } else {
                                return ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    scrollDirection: Axis.vertical,
                                    itemCount: snapshot.data!.docs.length,
                                    itemBuilder: (context, index) {
                                      provider.imageDec = snapshot
                                          .data!.docs[index]['image']
                                          .toString();
                                      provider.idDoc =
                                          snapshot.data!.docs[index]['id'];
                                      return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(
                                              height: AppConstants.s20,
                                            ),
                                            Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            AppValues.m10),
                                                    child: SizedBox(
                                                      height: AppConstants
                                                          .imageHeight,
                                                      width: AppConstants
                                                          .imageWidth,
                                                      child: snapshot.data!
                                                                          .docs[
                                                                      index][
                                                                  'encryptedFile'] ==
                                                              null
                                                          ? Container(
                                                              color:
                                                                  AppColor.grey)
                                                          : Image.file(
                                                              File(snapshot
                                                                  .data!
                                                                  .docs[index][
                                                                      'encryptedFile']
                                                                  .toString()),
                                                              fit: BoxFit.cover,
                                                            ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            AppValues.m10),
                                                    child: SizedBox(
                                                      height: AppConstants
                                                          .imageHeight,
                                                      width: AppConstants
                                                          .imageWidth,
                                                      child: provider
                                                                  .decryptedDES ==
                                                              null
                                                          ? Container(
                                                              color:
                                                                  AppColor.grey,
                                                              child: provider
                                                                          .newImage ==
                                                                      null
                                                                  ? Container(
                                                                      color: AppColor
                                                                          .grey)
                                                                  : Image.file(
                                                                      provider
                                                                          .newImage!,
                                                                      height:
                                                                          120,
                                                                      width:
                                                                          120,
                                                                      fit: BoxFit
                                                                          .cover,
                                                                    ),
                                                            )
                                                          : Image.memory(
                                                              Uint8List.fromList(
                                                                  provider
                                                                      .decryptedDES!),
                                                              height: 120,
                                                              width: 120,
                                                              fit: BoxFit.cover,
                                                            ),
                                                    ),
                                                  ),
                                                ]),
                                            Text(
                                              '  The Algorithm  is : ${snapshot.data!.docs[index]['algorithm']}',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium,
                                            ),
                                            Text(
                                              '  Mode Operation is : ${snapshot.data!.docs[index]['modeOperation']}',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium,
                                            ),
                                            const SizedBox(
                                              height: AppConstants.s20,
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal:
                                                          AppValues.m10),
                                              child: ElevatedButton(
                                                  onPressed: () async {
                                                    if (snapshot.data!.docs[index]['algorithm'].toString() ==
                                                            AppStrings.aes &&
                                                        snapshot.data!.docs[index]['modeOperation'].toString() ==
                                                            AppStrings.cbcMode) {
                                                      setState(() {
                                                        provider.newImage =
                                                            File(snapshot
                                                                .data!
                                                                .docs[index]
                                                                    ['image']
                                                                .toString());
                                                      });

                                                      await provider.decryptCBC(
                                                          snapshot.data!
                                                                  .docs[index]
                                                              ['encryptedFile'],
                                                          Uint8List.fromList(
                                                              (snapshot.data!.docs[
                                                                              index]
                                                                          ['AESKey']
                                                                      as List)
                                                                  .map((e) =>
                                                                      e as int)
                                                                  .toList()),
                                                          Uint8List.fromList(
                                                              (snapshot.data!.docs[
                                                              index]
                                                              ['AESIV']
                                                              as List)
                                                                  .map((e) =>
                                                              e as int)
                                                                  .toList()));
                                                    } else if (snapshot.data!.docs[index]['algorithm']
                                                                .toString() ==
                                                            AppStrings.aes &&
                                                        snapshot.data!.docs[index]['modeOperation']
                                                                .toString() ==
                                                            AppStrings
                                                                .ecbMode) {

                                                      setState(() {
                                                        provider.newImage =
                                                            File(snapshot
                                                                .data!
                                                                .docs[index]
                                                            ['image']
                                                                .toString());
                                                      });

                                                      await provider.decryptECB(
                                                          snapshot.data!
                                                              .docs[index]
                                                          ['encryptedFile'],
                                                          Uint8List.fromList(
                                                              (snapshot.data!.docs[
                                                              index]
                                                              ['AESKey']
                                                              as List)
                                                                  .map((e) =>
                                                              e as int)
                                                                  .toList()),
                                                          Uint8List.fromList(
                                                              (snapshot.data!.docs[
                                                              index]
                                                              ['AESIV']
                                                              as List)
                                                                  .map((e) =>
                                                              e as int)
                                                                  .toList()));
                                                    } else if (snapshot.data!.docs[index]['algorithm'].toString() ==
                                                            AppStrings.des &&
                                                        snapshot.data!.docs[index]['modeOperation']
                                                                .toString() ==
                                                            AppStrings.cbcMode) {
                                                      await provider.desCBC(
                                                          snapshot.data!
                                                              .docs[index]
                                                          ['image'],
                                                          snapshot.data!
                                                              .docs[index]
                                                          ['encryptedFile'],
                                                          DESMode.CBC);
                                                    } else if (snapshot.data!.docs[index]['algorithm']
                                                                .toString() ==
                                                            AppStrings.des &&
                                                        snapshot
                                                                .data!
                                                                .docs[index]
                                                                    ['modeOperation']
                                                                .toString() ==
                                                            AppStrings.ecbMode) {
                                                      await provider.desECB(
                                                          snapshot.data!
                                                                  .docs[index]
                                                              ['image'],
                                                          snapshot.data!
                                                                  .docs[index]
                                                              ['encryptedFile'],
                                                          DESMode.ECB);
                                                    }
                                                    TextFunctions.showToast(
                                                        'The Decryption has been completed unsuccessfully.');
                                                  },
                                                  child: const Text(
                                                      AppStrings.decryption)),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(
                                                  AppValues.m10),
                                              child: ElevatedButton(
                                                  onPressed: () async {
                                                    FirebaseFirestore.instance
                                                        .collection('images')
                                                        .doc(provider.idDoc!)
                                                        .delete();
                                                  },
                                                  child: const Text(
                                                      AppStrings.clear)),
                                            ),
                                            const SizedBox(
                                              height: AppValues.p15,
                                            ),
                                          ]);
                                    });
                              }
                            }),
                      ])));
        }));
  }
}
