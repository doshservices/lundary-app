import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(Icons.arrow_back_ios_rounded),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 6,
                      ),
                      Text(
                        "Privacy Policy",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 28),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Privacy Policy for Nathans Limited",
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
                  ),
                  SizedBox(height: 5),
                  RichText(
                    text: TextSpan(
                        style: TextStyle(color: Colors.black),
                        children: [
                          TextSpan(
                              text:
                                  "At Nathansdrycleaners, accessible from our website one of our main priorities is the privacy of our visitors. This Privacy Policy document contains types of information that is collected and recorded by nathansdrycleaners.com and how we use it."),
                          TextSpan(
                              text:
                                  " If you have additional questions or require more information about our Privacy Policy, do not hesitate to contact us"),
                          TextSpan(
                              text:
                                  " If you have additional questions or require more information about our Privacy Policy, do not hesitate to contact us."),
                          TextSpan(
                            text:
                                "This Privacy Policy applies only to our online activities and is valid for visitors to our website with regards to the information that they shared and/or collect in nathansdrycleaners.com. This policy is not applicable to any information collected offline or via channels other than this website."
                                "",
                          )
                        ]),
                    textAlign: TextAlign.justify,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  // Text(
                  //   'Consent',
                  //   style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                  // ),
                  // Text(
                  //     "By using our website, you hereby consent to our Privacy Policy and agree to its terms."),
                  // SizedBox(
                  //   height: 20,
                  // ),
                  Text(
                    "Information we collect",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                  ),
                  SizedBox(height: 5),
                  RichText(
                      text: TextSpan(
                          style: TextStyle(color: Colors.black),
                          children: [
                        TextSpan(
                            text:
                                "The personal information that you are asked to provide, and the reasons why you are asked to provide it, will be made clear to you at the point we ask you to provide your personal information"),
                        TextSpan(
                            text:
                                " If you contact us directly, we may receive additional information about you such as your name, email address, phone number, the contents of the message and/or attachments you may send us, and any other information you may choose to provide."),
                        TextSpan(
                            text:
                                "When you register for an Account, we may ask for your contact information, including items such as name, company name, address, email address, and telephone number.")
                      ])),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Log Files",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                  ),
                  SizedBox(height: 5),
                  RichText(
                      text: TextSpan(
                          style: TextStyle(color: Colors.black),
                          children: [
                        TextSpan(
                            text:
                                "nathansdrycleaners.com follows a standard procedure of using log files. These files log visitors when they visit websites. All hosting companies do this and a part of hosting services’ analytics"),
                        TextSpan(
                            text:
                                " The information collected by log files include internet protocol (IP) addresses, browser type, Internet Service Provider (ISP), date and time stamp, referring/exit pages, and possibly the number of clicks."),
                        TextSpan(
                            text:
                                " These are not linked to any information that is personally identifiable. The purpose of the information is for analyzing trends, administering the site, tracking users’ movement on the website, and gathering demographic information")
                      ])),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Cookies and Web Beacon",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                  ),
                  SizedBox(height: 5),
                  RichText(
                      text: TextSpan(
                          style: TextStyle(color: Colors.black),
                          children: [
                        TextSpan(
                            text:
                                "Like any other website, nathansdrycleaners.com uses ‘cookies’. These cookies are used to store information including visitors’ preferences, and the pages"),
                        TextSpan(
                            text:
                                "  on the website that the visitor accessed or visited. The information is used to optimize the users’ experience by"),
                        TextSpan(
                            text:
                                " customizing our web page content based on visitors’ browser type and/or other information")
                      ])),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Advertising Partners Privacy Policies",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                  ),
                  SizedBox(height: 5),
                  RichText(
                      text: TextSpan(
                          style: TextStyle(color: Colors.black),
                          children: [
                        TextSpan(
                            text:
                                "You may consult this list to find the Privacy Policy for each of the advertising partners of nathansdrycleaners.com."),
                        TextSpan(
                            text:
                                "  Third-party ad servers or ad networks uses technologies like cookies, JavaScript, or Web Beacons that are used in their respective advertisements and links that appear on nathansdrycleaners.com, which are sent directly to users’ browser. They automatically receive your IP address when this occurs. These technologies are used to measure the effectiveness of their advertising campaigns and/or to personalize the advertising content that you see on websites that you visit."),
                        TextSpan(
                            text:
                                " Note that nathansdrycleaners.com has no access to or control over these cookies that are used by third-party advertisers.")
                      ])),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Third Party Privacy Policy",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                  ),
                  SizedBox(height: 5),
                  RichText(
                      text: TextSpan(
                          style: TextStyle(color: Colors.black),
                          children: [
                        TextSpan(
                            text:
                                "nathansdrycleaners.com’s Privacy Policy does not apply to other advertisers or websites. Thus, we are advising you to consult the respective Privacy Policies of these third-party"),
                        TextSpan(
                            text:
                                " ad servers for more detailed information. It may include their practices and instructions about how to opt-out of certain options."),
                        TextSpan(
                            text:
                                "   You can choose to disable cookies through your individual browser options. To know more detailed information about cookie management with specific web browsers, it can be found at the browsers’ respective websites.")
                      ])),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Children's Information",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                  ),
                  SizedBox(height: 5),
                  RichText(
                      text: TextSpan(
                          style: TextStyle(color: Colors.black),
                          children: [
                        TextSpan(
                            text:
                                "Another part of our priority is adding protection for children while using the internet. We encourage parents and guardians to observe, participate in,"),
                        TextSpan(
                            text:
                                " and/or monitor and guide their online activity. nathansdrycleaners.com does not knowingly collect any Personal Identifiable Information from children under the age of 13."),
                        TextSpan(
                            text:
                                "If you think that your child provided this kind of information on our website, we strongly encourage you to contact us immediately and we will do our best efforts to promptly remove such information from our records.")
                      ])),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
