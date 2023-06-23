import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pra_tvi_web/controller/box_controller.dart';
import 'package:pra_tvi_web/core/color_constants.dart';
import 'package:pra_tvi_web/core/description_data.dart';
import 'package:pra_tvi_web/widgets/custom_appbar.dart';
import 'package:resize/resize.dart';

class BusStatusPage extends StatefulWidget {
  const BusStatusPage({Key? key}) : super(key: key);

  @override
  State<BusStatusPage> createState() => _BusStatusPageState();
}

class _BusStatusPageState extends State<BusStatusPage> {
  final controller = Get.find<BoxController>();

  @override
  Widget build(BuildContext context) {
    final busses = controller.getBusList();

    return Scaffold(
      appBar: CustomAppBar.customAppBar(
        'Bus Current Status',
        backEnabled: false,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await controller.getBusData();
          setState(() {});
        },
        child: ListView.builder(
          shrinkWrap: true,
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.only(right: 10.sp, left: 10.sp, top:10.sp, bottom: 70.sp,),
          itemBuilder: (ctx, index) => BusItem(
            bus: busses[index],
            index: index,
            status: controller.getBusStatusString(busses[index]),
            onChange: (status) async {
              await controller.changeBusStatus(busses[index], status);
              await controller.getBusData();
              setState(() {});
            },
          ),
          itemCount: busses.length,
        ),
      ),
    );
  }
}

class BusItem extends StatelessWidget {
  const BusItem({
    Key? key,
    required this.bus,
    required this.index,
    required this.status,
    required this.onChange,
  }) : super(key: key);

  final String bus;
  final int index;
  final String status;
  final Function(int) onChange;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Container(
      width: screenSize.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.sp),
        color: Colors.white.withOpacity(0.8),
      ),
      padding: EdgeInsets.all(10.sp),
      margin: EdgeInsets.only(bottom: 10.sp),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              bus,
              style: TextStyle(fontSize: 15.sp),
            ),
          ),
          InkWell(
            onTap: () => onChange(2),
            child: Container(
              width: 80.sp,
              height: 30.sp,
              margin: EdgeInsets.only(left: 5.sp),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(8.sp)),
                color: status == Descriptions.busStatus[2]
                    ? AppColors().lightGreen
                    : Colors.grey,
              ),
              alignment: Alignment.center,
              child: Text(
                'Waiting',
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          SizedBox(
            width: 8.sp,
          ),
          InkWell(
            onTap: () => onChange(0),
            child: Container(
              width: 80.sp,
              height: 30.sp,
              margin: EdgeInsets.only(left: 5.sp),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(8.sp)),
                color: status == Descriptions.busStatus[0]
                    ? AppColors().lightGreen
                    : Colors.grey,
              ),
              alignment: Alignment.center,
              child: Text(
                'Left',
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          SizedBox(
            width: 8.sp,
          ),
          InkWell(
            onTap: () => onChange(1),
            child: Container(
              width: 80.sp,
              height: 30.sp,
              margin: EdgeInsets.only(left: 5.sp),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(8.sp)),
                color: status == Descriptions.busStatus[1]
                    ? AppColors().lightGreen
                    : Colors.grey,
              ),
              alignment: Alignment.center,
              child: Text(
                'Arrived',
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
