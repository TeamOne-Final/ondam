import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ondam_app/vm/vm_handler_temp.dart';

class CompanyEmployee extends StatelessWidget {
  CompanyEmployee({super.key});
  final VmHandlerTemp controller = Get.find<VmHandlerTemp>();

  @override
  Widget build(BuildContext context) {
    controller.fetchEmployee();
    return Scaffold(
      backgroundColor: Color(0xFFF6F7FB),
      body: Row(
        children: [
          // CompanySideMenu(),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(40, 40, 20, 20),
                      child: Text('직원관리', style: TextStyle(fontSize: 40)),
                    ),
                  ],
                ),
                Obx(
                  () => Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 20,
                      ),
                      itemCount: controller.employeeList.length,
                      itemBuilder: (context, index) {
                        final employee = controller.employeeList[index];
                        return Center(
                          child: Container(
                            width: MediaQuery.of(context).size.width/1.5,
                            margin: EdgeInsets.only(bottom: 16),
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white, // 배경 색
                              borderRadius: BorderRadius.circular(
                                16,
                              ), // 모서리 둥글게
                              boxShadow: [
                                // 그림자 효과
                                BoxShadow(
                                  color: Colors.grey.withAlpha(
                                    (255 * 0.2).round(),
                                  ),
                                  blurRadius: 8,
                                  offset: Offset(0, 4),
                                ),
                              ],
                              border: Border.all(
                                color: Colors.grey.shade300,
                              ), // 연한 테두리
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // 이미지
                                SizedBox(width: 20),
                                // 이름과 가격
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        employee.managerId,
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        employee.companyCode,
                                        style: TextStyle(
                                          fontSize: 22,
                                          color: Colors.black54,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        employee.location,
                                        style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // 버튼들
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
