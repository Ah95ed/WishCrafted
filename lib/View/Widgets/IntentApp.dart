import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wishcrafted/Controller/DashboardContorller/dashboardcontroller.dart';
import 'package:wishcrafted/Models/dasshboardModel/dasshboardModel.dart';
import 'package:wishcrafted/View/Widgets/AccessibleText/AccessibleText.dart';
import 'package:wishcrafted/View/style/SizeApp/ScreenSize.dart';

class IntentDropdownScreen extends StatefulWidget {
  const IntentDropdownScreen({super.key});

  @override
  State<IntentDropdownScreen> createState() => _IntentDropdownScreenState();
}

class _IntentDropdownScreenState extends State<IntentDropdownScreen> {
  @override
  Widget build(BuildContext context) {
    final dashboardController = Provider.of<DashboardController>(context);
    DashboardModel? selectedIntent = dashboardController.selectedIntent;
    List<DashboardModel> intents = dashboardController.intents;

    return SizedBox(
      height: context.getHeight(220),
      child: ListView.separated(
        itemCount: intents.length,
        separatorBuilder: (context, i) => SizedBox(height: 8),
        itemBuilder: (context, i) {
          DashboardModel intent = intents[i];
          bool isSelected = selectedIntent == intent;
          return Material(
            color: isSelected
                ? Theme.of(context).colorScheme.secondary
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () {
                dashboardController.setSelectedIntent(intent);
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 18, horizontal: 14),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: isSelected
                        ? Theme.of(context).colorScheme.secondary
                        : Colors.grey.shade300,
                    width: isSelected ? 2 : 1,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  color: isSelected
                      ? Theme.of(context).colorScheme.secondary
                      : Colors.white,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          isSelected
                              ? Icons.radio_button_checked
                              : Icons.radio_button_off,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        SizedBox(width: context.getWidth(8)),
                        Expanded(
                          child: AccessibleText(
                            intent.title ?? "",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: context.getFontSize(15),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: context.getHeight(6)),
                    AccessibleText(
                      intent.description ?? "",
                      style: TextStyle(
                        fontSize: context.getFontSize(13),
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
