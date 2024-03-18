// ignore_for_file: library_private_types_in_public_api, camel_case_types, non_constant_identifier_names, use_build_context_synchronously

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Open_Feedback_Details_Screen extends StatefulWidget {
  final String fid;

  const Open_Feedback_Details_Screen(
      {super.key,
        required this.fid});

  @override
  _Open_Feedback_Details_ScreenState createState() => _Open_Feedback_Details_ScreenState();
}

class _Open_Feedback_Details_ScreenState extends State<Open_Feedback_Details_Screen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String fetchedFid = "";
  String serviceFulfill = '';
  String starCount = '';
  String fetchedDesc = '';

  int _starRating = 3;
  bool _thumbsUpSelected = false;
  bool _thumbsDownSelected = false;

  TextEditingController descController = TextEditingController();

  @override
  void initState() {
    fetchFeedbackData().then((value) => descController.text = fetchedDesc);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blueGrey.shade50,
        appBar: AppBar(
          elevation: 50,
          backgroundColor: Colors.black12,
          centerTitle: true,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(25),
                  bottomLeft: Radius.circular(25))),
          title: const Text("Submit feedback"),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 15),
                  //stars
                  Padding(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 15),
                        child: Column(
                          children: [
                            const Text(
                              "Select rating as per service :",
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 15),
                            Row(
                              //mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(width: 18),
                                Row(
                                  children: List.generate(
                                    5,
                                        (index) => GestureDetector(
                                      //onTap: () => _selectStar(index + 1),
                                      child: Icon(
                                        index < _starRating
                                            ? Icons.star
                                            : Icons.star_border,
                                        color: Colors.orangeAccent,
                                        size: 35,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 18),
                                Text(
                                  getRatingString(_starRating),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 5),
                  // Padding(
                  //   padding: const EdgeInsets.all(8.0),
                  //   child: Row(
                  //     children: [
                  //       const Text('Selected Rating:'),
                  //       const SizedBox(width: 10),
                  //       Text(_starRating.toString()),
                  //     ],
                  //   ),
                  // ),
                  // Padding(
                  //   padding: const EdgeInsets.all(8.0),
                  //   child: Row(
                  //     children: [
                  //       const Text('Select emojis:'),
                  //       const SizedBox(width: 10),
                  //       // Display different emojis based on star rating
                  //       _starRating == 1
                  //           ? const Text('Poor')
                  //           : _starRating == 2
                  //               ? const Text('Fair')
                  //               : _starRating == 3
                  //                   ? const Text('Average')
                  //                   : _starRating == 4
                  //                       ? const Text('Good')
                  //                       : _starRating == 5
                  //                           ? const Text('Excellent')
                  //                           : const Text(''),
                  //     ],
                  //   ),
                  // ),
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 7),
                  //   //btn
                  //   child: Container(
                  //     decoration: const BoxDecoration(
                  //       color: Colors.white,
                  //       borderRadius: BorderRadius.all(Radius.circular(12)),
                  //     ),
                  //     child: Padding(
                  //       padding:
                  //           const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  //       child: Column(
                  //         mainAxisAlignment: MainAxisAlignment.start,
                  //         crossAxisAlignment: CrossAxisAlignment.start,
                  //         children: [
                  //           const Padding(
                  //             padding: EdgeInsets.only(left: 10, top: 5),
                  //             child: Text('What can be improved ?',
                  //                 style: TextStyle(
                  //                     fontSize: 17, fontWeight: FontWeight.w600)),
                  //           ),
                  //           const SizedBox(height: 15),
                  //           // Display custom checkboxes
                  //           Wrap(
                  //             children: [
                  //               Row(
                  //                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //                 children: [
                  //                   GestureDetector(
                  //                     onTap: () => _toggleCheckbox(0),
                  //                     child: Container(
                  //                       margin: const EdgeInsets.all(5),
                  //                       padding: const EdgeInsets.all(8),
                  //                       decoration: BoxDecoration(
                  //                         color: _checkboxValues[0]
                  //                             ? Colors.green.shade200
                  //                             : Colors.grey.shade200,
                  //                         borderRadius: BorderRadius.circular(5),
                  //                         border: Border.all(color: Colors.grey),
                  //                       ),
                  //                       child: const Padding(
                  //                         padding:
                  //                             EdgeInsets.symmetric(horizontal: 20),
                  //                         child: Text('Checkbox 1'),
                  //                       ),
                  //                     ),
                  //                   ),
                  //                   const SizedBox(width: 10),
                  //                   GestureDetector(
                  //                     onTap: () => _toggleCheckbox(1),
                  //                     child: Container(
                  //                       margin: const EdgeInsets.all(5),
                  //                       padding: const EdgeInsets.all(8),
                  //                       decoration: BoxDecoration(
                  //                         color: _checkboxValues[1]
                  //                             ? Colors.green.shade200
                  //                             : Colors.grey.shade200,
                  //                         borderRadius: BorderRadius.circular(5),
                  //                         border: Border.all(color: Colors.grey),
                  //                       ),
                  //                       child: const Padding(
                  //                         padding:
                  //                             EdgeInsets.symmetric(horizontal: 20),
                  //                         child: Text('Checkbox 2'),
                  //                       ),
                  //                     ),
                  //                   ),
                  //                 ],
                  //               ),
                  //               const SizedBox(height: 13),
                  //               Row(
                  //                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //                 children: [
                  //                   GestureDetector(
                  //                     onTap: () => _toggleCheckbox(2),
                  //                     child: Container(
                  //                       margin: const EdgeInsets.all(5),
                  //                       padding: const EdgeInsets.all(8),
                  //                       decoration: BoxDecoration(
                  //                         color: _checkboxValues[2]
                  //                             ? Colors.green.shade200
                  //                             : Colors.grey.shade200,
                  //                         borderRadius: BorderRadius.circular(5),
                  //                         border: Border.all(color: Colors.grey),
                  //                       ),
                  //                       child: const Padding(
                  //                         padding:
                  //                             EdgeInsets.symmetric(horizontal: 20),
                  //                         child: Text('Checkbox 4'),
                  //                       ),
                  //                     ),
                  //                   ),
                  //                   const SizedBox(width: 10),
                  //                   GestureDetector(
                  //                     onTap: () => _toggleCheckbox(3),
                  //                     child: Container(
                  //                       margin: const EdgeInsets.all(5),
                  //                       padding: const EdgeInsets.all(8),
                  //                       decoration: BoxDecoration(
                  //                         color: _checkboxValues[3]
                  //                             ? Colors.green.shade200
                  //                             : Colors.grey.shade200,
                  //                         borderRadius: BorderRadius.circular(5),
                  //                         border: Border.all(color: Colors.grey),
                  //                       ),
                  //                       child: const Padding(
                  //                         padding:
                  //                             EdgeInsets.symmetric(horizontal: 20),
                  //                         child: Text('Checkbox 5'),
                  //                       ),
                  //                     ),
                  //                   ),
                  //                 ],
                  //               ),
                  //             ],
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //   ),
                  // ),

                  //other
                  Padding(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 5, vertical: 7),
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 15),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(left: 10, top: 5),
                              child: Text(
                                  'Tell us more !',
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w600)),
                            ),
                            const SizedBox(height: 15),
                            // Display custom checkboxes
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Was your request fulfilled ? :'),
                                const Spacer(),
                                const SizedBox(width: 10),
                                // Display thumbs up and thumbs down icons
                                GestureDetector(
                                  onTap: () {
                                    //_thumbsUpSelected = !_thumbsUpSelected;
                                    setState(() {
                                      _thumbsDownSelected = false;
                                      //_showError = false;
                                    });
                                  },
                                  child: Icon(
                                    Icons.thumb_up,
                                    color: _thumbsUpSelected
                                        ? Colors.blue
                                        : Colors.grey,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                GestureDetector(
                                  onTap: () {
                                    //_thumbsDownSelected = !_thumbsDownSelected;
                                    setState(() {
                                      _thumbsUpSelected = false;
                                      //_showError = false;
                                    });
                                  },
                                  child: Icon(
                                    Icons.thumb_down,
                                    color: _thumbsDownSelected
                                        ? Colors.blue
                                        : Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 15),
                          ],
                        ),
                      ),
                    ),
                  ),

                  Padding(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 5, vertical: 7),
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 15),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(left: 10, top: 5),
                              child: Text('Add detailed review !',
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w600)),
                            ),
                            const SizedBox(height: 15),
                            //desc
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                enabled: false,
                                textCapitalization:
                                TextCapitalization.sentences,
                                controller: descController,
                                maxLength: 100,
                                decoration: const InputDecoration(
                                 // hintText: 'Write your feedback here ...',
                                  // border: OutlineInputBorder(
                                  //     borderRadius:
                                  //         BorderRadius.all(Radius.circular(5))),
                                ),
                                maxLines: 5,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Feedback is required';
                                  } else if (value.length < 3) {
                                    return 'Too short feedback ..';
                                  }
                                  return null; // Return null if the input is valid
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                  // const Spacer(
                  //   flex: 1,
                  // ),
                  //const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.only(right: 20, left: 20, bottom: 15),
          child: ElevatedButton(
            onPressed: () async {
              // if (!_thumbsUpSelected && !_thumbsDownSelected) {
              //   setState(() {
              //     _showError = true;
              //   });
              //   return;
              // }
              //
              // setState(() {
              //   _showError = false;
              // });
              // if (_formKey.currentState!.validate()) {
              //   //progress
              //   showDialog(
              //     context: context,
              //     barrierDismissible: false,
              //     builder: (BuildContext context) {
              //       return const Dialog(
              //         child: Padding(
              //           padding: EdgeInsets.only(
              //               top: 35, bottom: 25, left: 20, right: 20),
              //           child: Column(
              //             mainAxisSize: MainAxisSize.min,
              //             crossAxisAlignment: CrossAxisAlignment.center,
              //             mainAxisAlignment: MainAxisAlignment.center,
              //             children: [
              //               SizedBox(height: 15),
              //               CircularProgressIndicator(color: Colors.blue),
              //               SizedBox(height: 30),
              //               Text('Processing ...')
              //             ],
              //           ),
              //         ),
              //       );
              //     },
              //   );
              //   await Future.delayed(const Duration(milliseconds: 1300));
              //
              //   CollectionReference citizenFeedbackCollection =
              //   FirebaseFirestore.instance.collection("clc_feedback");
              //
              //   try {
              //     QuerySnapshot snapshot =
              //     await citizenFeedbackCollection.get();
              //     int totalDocCount = snapshot.size;
              //     totalDocCount++;
              //
              //     //govt
              //     if (widget.authority_id.startsWith("g")) {
              //       await FirebaseFirestore.instance
              //           .collection("clc_response")
              //           .doc(widget.respond_id)
              //           .collection("govt")
              //           .doc("govt_details")
              //           .update({
              //         'fid': "Feedback_${totalDocCount.toString()}",
              //       });
              //     }
              //     //ngo
              //     else if (widget.authority_id.startsWith("n")) {
              //       await FirebaseFirestore.instance
              //           .collection("clc_response")
              //           .doc(widget.respond_id)
              //           .collection("ngo")
              //           .doc("ngo_details")
              //           .update({
              //         'fid': "Feedback_${totalDocCount.toString()}",
              //       });
              //     }
              //
              //     //addFeedbackToDatabase(totalDocCount);
              //   } catch (e) {
              //     if (kDebugMode) {
              //       print('Error while sending citizen request : $e');
              //     }
              //   } finally {
              //     Navigator.pop(context);
              //   }
              // }
            },
            style: ButtonStyle(enableFeedback: false,
              backgroundColor: const MaterialStatePropertyAll(Colors.grey),
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              )),
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 0),
              child: Text("Submit"),
            ),
          ),
        ));
  }

  Future<void> fetchFeedbackData() async {
    try {

      // Fetch data from Firestore
      DocumentSnapshot feedbackSnapshot = await FirebaseFirestore.instance
          .collection('clc_feedback')
          .doc(widget.fid)
          .get();

      // Check if the document exists
      if (feedbackSnapshot.exists) {
        setState(() {
          fetchedFid = feedbackSnapshot.get('feedback_id');
          starCount = feedbackSnapshot.get('selectedStar');
          serviceFulfill = feedbackSnapshot.get('serviceFulfilled');
          fetchedDesc = feedbackSnapshot.get('description');
          _starRating = mapRatingStringToStar(starCount);
          if (serviceFulfill == 'Yes') {
            _thumbsUpSelected = true;
            _thumbsDownSelected = false;
          } else if (serviceFulfill == 'No') {
            _thumbsUpSelected = false;
            _thumbsDownSelected = true;
          }

        });
      } else {
        if (kDebugMode) {
          print('Document does not exist');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching feedback data : $e');
      }
    }
  }

  String getRatingString(int starRating) {
    switch (starRating) {
      case 1:
        return 'Poor';
      case 2:
        return 'Fair';
      case 3:
        return 'Average';
      case 4:
        return 'Good';
      case 5:
        return 'Excellent';
      default:
        return '';
    }
  }

  int mapRatingStringToStar(String ratingString) {
    switch (ratingString) {
      case "Poor":
        return 1;
      case "Fair":
        return 2;
      case "Average":
        return 3;
      case "Good":
        return 4;
      case "Excellent":
        return 5;
      default:
        return 3; // Default to 3 if the rating string is unknown or null
    }
  }
}