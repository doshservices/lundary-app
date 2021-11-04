import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  "Our Privacy Policy",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 28),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Privacy Policy for Nathans Limited",
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
              ),
              RichText(
                text: TextSpan(children: [
                  TextSpan(
                      text:
                          "At nathansdrycleaners.com, accessible from ${'https://nathansdrycleaners.com/'} one of our main priorities is the privacy of our visitors. This Privacy Policy document contains types of information that is collected and recorded by nathansdrycleaners.com and how we use it."),
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
              Text(
                'Consent',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
              ),
              Text(
                  "By using our website, you hereby consent to our Privacy Policy and agree to its terms."),
              SizedBox(
                height: 20,
              ),
              Text(
                "Information we collect",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
              ),
              RichText(
                  text: TextSpan(children: [
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
              RichText(
                  text: TextSpan(children: [
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
              Text(
                "Cookies and Web Beacon",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
              ),
              Text(
                  """Like any other website, nathansdrycleaners.com uses ‘cookies’. These cookies are used to store information including visitors’ preferences, and the pages
                   on the website that the visitor accessed or visited. The information is used to optimize the users’ experience by
                   customizing our web page content based on visitors’ browser type and/or other information."""),
              SizedBox(
                height: 20,
              ),
              Text(
                "Advertising Partners Privacy Policies",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
              ),
              Text(
                  """You may consult this list to find the Privacy Policy for each of the advertising partners of nathansdrycleaners.com.
      
      Third-party ad servers or ad networks uses technologies like cookies, JavaScript, or Web Beacons that are used in their respective advertisements and links that appear on nathansdrycleaners.com, which are sent directly to users’ browser. They automatically receive your IP address when this occurs. These technologies are used to measure the effectiveness of their advertising campaigns and/or to personalize the advertising content that you see on websites that you visit.
      
      Note that nathansdrycleaners.com has no access to or control over these cookies that are used by third-party advertisers."""),
              Text(
                "Third Party Privacy Policy",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
              ),
              Text(
                  """nathansdrycleaners.com’s Privacy Policy does not apply to other advertisers or websites. Thus, we are advising you to consult the respective Privacy Policies of these third-party ad servers for more detailed information. It may include their practices and instructions about how to opt-out of certain options.
      
      You can choose to disable cookies through your individual browser options. To know more detailed information about cookie management with specific web browsers, it can be found at the browsers’ respective websites.
      
      """),
              SizedBox(
                height: 20,
              ),
              Text(
                "Children's Information",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
              ),
              Text(
                  """Another part of our priority is adding protection for children while using the internet. We encourage parents and guardians to observe, participate in, and/or monitor and guide their online activity.
      
      nathansdrycleaners.com does not knowingly collect any Personal Identifiable Information from children under the age of 13. If you think that your child provided this kind of information on our website, we strongly encourage you to contact us immediately and we will do our best efforts to promptly remove such information from our records.""")
            ],
          ),
        ),
      ),
    );
  }
}
