import 'package:flutter/material.dart';
import 'package:wishcrafted/View/DashBoardScreen/ChatAi.dart';
import 'package:wishcrafted/View/Widgets/CurveClipper/CurveClipper.dart';
import 'package:wishcrafted/View/Widgets/ChatHistoryDrawer/ChatHistoryDrawer.dart';
import 'package:wishcrafted/View/style/SizeApp/ScreenSize.dart';
import 'package:wishcrafted/View/style/AppColors/AppColors.dart';
import 'package:provider/provider.dart';
import 'package:wishcrafted/Controller/DashboardContorller/dashboardcontroller.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  TextEditingController _intentController = TextEditingController();
  int? isSelected;
    GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();


  @override
  void initState() {
    super.initState();
    // تحميل المحادثات المحفوظة عند بدء الشاشة
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<DashboardController>(
        context,
        listen: false,
      ).loadChatSessions();
    });
  }

  @override
  Widget build(BuildContext context) {
    final dashboardController = Provider.of<DashboardController>(context);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.background,
      drawer: ChatHistoryDrawer(),
      body: Stack(
        children: [
          // منحنى علوي
          Positioned(
            top: -context.getHeight(20),
            left: 0,
            right: 0,
            // bottom: 0,
            child: ClipPath(
              clipper: TopCurveClipper(),
              child: Container(
                height: context.getHeight(150),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.curveTop1, AppColors.curveTop2],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // زر فتح الدراوير
                    IconButton(
                      onPressed: () {
                        _scaffoldKey.currentState?.openDrawer();
                        // Scaffold.of(context).openDrawer();
                      },
                      icon: Icon(Icons.menu, color: AppColors.textMain, size: 28),
                    ),
                
                    // العنوان
                    Text(
                      'WishCrafted AI',
                      style: TextStyle(
                        color:AppColors.textMain,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                   
                
                    // زر محادثة جديدة
                    IconButton(
                      onPressed: () {
                        dashboardController.startNewChat();
                      },
                      icon: Icon(
                        Icons.add_comment,
                        color: AppColors.textMain,
                        size: 28,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // منحنى سفلي
          Align(
            alignment: Alignment.bottomCenter,
            child: ClipPath(
              clipper: BottomCurveClipper(),
              child: Container(
                height: context.getHeight(70),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.curveBottom1, AppColors.curveBottom2],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),
          ),

          // المحتوى مع Scroll
          Center(
            child: SafeArea(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                padding: EdgeInsets.all(context.getMinSize(4)),
                child: Container(
                  height: context.screenHeight * .8,
                  decoration: BoxDecoration(
                    border: Border.all(),

                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(context.getMinSize(16)),
                  ),

                  child: Padding(
                    padding: EdgeInsets.all(context.getMinSize(6)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SingleChildScrollView(
                          child: SizedBox(
                            height: context.screenHeight * .7,
                            child: ChatScreen(
                              dashboardController.messages,
                              embedded: true,
                              externalIsLoading: dashboardController.isLoading,
                            ),
                          ),
                        ),

                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                maxLines: 1,
                                controller: _intentController,
                                decoration: InputDecoration(
                                  labelText: "أدخل رسالتك للذكاء الاصطناعي",
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),

                            ElevatedButton(
                              child: Icon(
                                Icons.send,
                                size: context.getFontSize(24),
                              ),
                              onPressed: () async {
                                // IntentApp.intent(dashboardController.selectedIntent!);
                                var text = _intentController.text.trim();
                                await dashboardController.askGemini(text);
                                _intentController.clear();
                                text = '';
                                // if (dashboardController.selectedIntent!.title !=
                                //     null) {
                                //   await dashboardController.askGemini(text);
                                // }
                                // dashboardController.selectedIntent!.title;
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
