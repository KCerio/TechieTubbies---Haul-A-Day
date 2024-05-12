import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:haul_a_day_web/newUI/components/dialogs/accApprovalDialog.dart';
import 'package:haul_a_day_web/newUI/components/dialogs/reassignDialog.dart';

class TrialPage extends StatelessWidget {
  const TrialPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Trial Page'),),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: NonInfiniteCarousel(),
        // child: Center(
        //   child: ElevatedButton(
        //     onPressed: () {
        //       showDialog<String>(
        //         context: context,
        //         builder: (BuildContext context) {
        //           return AlertDialog(
        //             contentPadding: EdgeInsets.zero,
        //             shape: RoundedRectangleBorder(
        //               borderRadius: BorderRadius.circular(15.0),
        //             ),
        //             content: AccountApprovalDialog()
        //           );
        //         },
        //       );
        //     },
        //     child: Text('Test'),5
        //   ),
        // ),
      )
    );
  }
}

class NonInfiniteCarousel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        enableInfiniteScroll: false, // Set this to false
        height: 200.0,
      ),
      items: [1, 2, 3, 4, 5].map((i) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.symmetric(horizontal: 5.0),
              decoration: BoxDecoration(
                color: Colors.amber,
              ),
              child: Center(
                child: Text(
                  'Image $i',
                  style: TextStyle(fontSize: 16.0),
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }
}