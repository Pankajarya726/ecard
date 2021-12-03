import 'package:e_card/utils/text_style.dart';
import 'package:e_card/widgets/background_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BackgroundImage(),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Text(
              "Notification",
              style: GoogleFonts.poppins(),
            ),
          ),
          body: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xff0F0211),
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(30),
                      topLeft: Radius.circular(30),
                    ),
                  ),
                  child: ListView(
                    children: [
                      SizedBox(
                        height: 30,
                      ),
                      Container(
                        margin: EdgeInsets.all(15),
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Color(0xff33113A),
                            borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "NOTIFICATION TITLE",
                                style: TextStylePage.headingHomeBold,
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                """Paris Saint-Germain Football Club (French pronunciation: ​[paʁi sɛ̃ ʒɛʁmɛ̃]), commonly referred to as Paris Saint-Germain, Paris SG, or simply Paris or PSG, is a professional football club based in Paris, France. They compete in Ligue 1, the top division of French football. PSG are France's most successful club, having won more tha France and one of the  long-standinge.""",
                                style: TextStylePage.headingHome15,
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                "2 Hours Ago",
                                style: TextStylePage.whiteText,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
