// import 'package:ai_powered_tourists_app/features/profile/screen/download_map.dart';
// import 'package:ai_powered_tourists_app/features/profile/screen/view_saved_map.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import '../../../utils/constants/colors.dart';
// import '../controller/profile_controller.dart';

// class SelectMap extends StatelessWidget {
//   const SelectMap({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final ProfileController controller = Get.find<ProfileController>();

//     return Scaffold(
//       backgroundColor: AppColors.backgroundColor,
//       appBar: AppBar(
//         backgroundColor: AppColors.backgroundColor,
//         elevation: 0,
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back, color: Colors.black),
//           onPressed: () => Get.back(),
//         ),
//         title: Text(
//           'Download Offline Map',
//           style: TextStyle(
//             color: Colors.black,
//             fontSize: 18,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//         centerTitle: false,
//       ),
//       body: Column(
//         children: [
//           // Download Maps Title
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Align(
//               alignment: Alignment.centerLeft,
//               child: Text(
//                 'Download Maps',
//                 style: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.w600,
//                   color: Colors.black,
//                 ),
//               ),
//             ),
//           ),

//           // Maps List
//           Expanded(
//             child: Obx(
//               () => controller.downloadedMaps.isEmpty
//                   ? Center(
//                       child: Text(
//                         'No downloaded maps',
//                         style: TextStyle(
//                           color: AppColors.textSecondary,
//                           fontSize: 16,
//                         ),
//                       ),
//                     )
//                   : ListView.builder(
//                       padding: EdgeInsets.symmetric(horizontal: 16),
//                       itemCount: controller.downloadedMaps.length,
//                       itemBuilder: (context, index) {
//                         final map = controller.downloadedMaps[index];
//                         return _buildMapCard(context, controller, map, index);
//                       },
//                     ),
//             ),
//           ),

//           // Select Your Own Map Button
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: SizedBox(
//               width: double.infinity,
//               height: 50,
//               child: Container(
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     colors: [
//                       AppColors.orangeStart,
//                       AppColors.orangeEnd,
//                     ],
//                     begin: Alignment.centerLeft,
//                     end: Alignment.centerRight,
//                   ),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: ElevatedButton(
//                   onPressed: () {
//                     // Handle select own map
//                     Get.to(()=>DownloadMap());
                
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.transparent,
//                     shadowColor: Colors.transparent,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                   ),
//                   child: Text(
//                     'Select your own map',
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.w600,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//                SizedBox(height: 20.h,),
//         ],
//       ),
//     );
//   }

//   Widget _buildMapCard(BuildContext context, ProfileController controller,
//       Map<String, dynamic> map, int index) {
//     return GestureDetector(
//       onTap: () {
//         // Navigate to view the selected map area
//         _viewMapArea(controller, index);
//       },
//       child: Container(
//         margin: EdgeInsets.only(bottom: 12),
//         padding: EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(12),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withValues(alpha: .05),
//               blurRadius: 10,
//               offset: Offset(0, 2),
//             ),
//           ],
//         ),
//         child: Row(
//           children: [
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     map['name'],
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.w600,
//                       color: Colors.black,
//                     ),
//                   ),
//                   SizedBox(height: 4),
//                   Text(
//                     'Last download ${map['lastDownloaded']}',
//                     style: TextStyle(
//                       fontSize: 12,
//                       color: AppColors.textSecondary,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           PopupMenuButton<String>(
//             icon: Icon(Icons.more_vert, color: Colors.black),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(12),
//             ),
//             itemBuilder: (context) => [
//               PopupMenuItem(
//                 value: 'rename',
//                 child: Row(
//                   children: [
//                     Icon(Icons.edit, size: 20, color: Colors.black),
//                     SizedBox(width: 12),
//                     Text('Rename'),
//                   ],
//                 ),
//               ),
//               PopupMenuItem(
//                 value: 'delete',
//                 child: Row(
//                   children: [
//                     Icon(Icons.delete, size: 20, color: Colors.red),
//                     SizedBox(width: 12),
//                     Text('Delete', style: TextStyle(color: Colors.red)),
//                   ],
//                 ),
//               ),
//             ],
//             onSelected: (value) {
//               if (value == 'rename') {
//                 controller.showRenameDialog(context, index);
//               } else if (value == 'delete') {
//                 _showDeleteConfirmation(context, controller, index);
//               }
//             },
//           ),
//         ],
//       ),
//       ),
//     );
//   }

//   void _showDeleteConfirmation(
//       BuildContext context, ProfileController controller, int index) {
//     Get.dialog(
//       AlertDialog(
//         title: Text('Delete Map'),
//         content: Text('Are you sure you want to delete this map?'),
//         actions: [
//           TextButton(
//             onPressed: () => Get.back(),
//             child: Text('Cancel'),
//           ),
//           TextButton(
//             onPressed: () {
//               controller.deleteMap(index);
//               Get.back();
//             },
//             child: Text('Delete', style: TextStyle(color: Colors.red)),
//           ),
//         ],
//       ),
//     );
//   }

//   void _viewMapArea(ProfileController controller, int index) {
//     if (index >= 0 && index < controller.downloadedMaps.length) {
//       final map = controller.downloadedMaps[index];
//       final mapName = map['name'];
//       final lat = map['latitude'] ?? controller.initialLat;
//       final lng = map['longitude'] ?? controller.initialLng;
//       final zoom = map['zoom'] ?? 15.0;
      
//       // Move camera to saved location
//       controller.moveCamera(lat, lng, zoom: zoom);
      
//       // Navigate to ViewSavedMap screen to view the area (without download button)
//       Get.to(() => ViewSavedMap(mapName: mapName));
//     }
//   }
// }
import 'package:ai_powered_tourists_app/features/profile/screen/download_map.dart';
import 'package:ai_powered_tourists_app/features/profile/screen/view_saved_map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../utils/constants/colors.dart';
import '../controller/profile_controller.dart';

class SelectMap extends StatelessWidget {
  const SelectMap({super.key});

  @override
  Widget build(BuildContext context) {
    final ProfileController controller = Get.find<ProfileController>();

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'download_offline_map'.tr,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          // Download Maps Title
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'download_maps'.tr,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ),
          ),

          // Maps List
          Expanded(
            child: Obx(
              () => controller.downloadedMaps.isEmpty
                  ? Center(
                      child: Text(
                        'no_downloaded_maps'.tr,
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 16,
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: controller.downloadedMaps.length,
                      itemBuilder: (context, index) {
                        final map = controller.downloadedMaps[index];

                        return _buildMapCard(
                          context,
                          controller,
                          map,
                          index,
                        );
                      },
                    ),
            ),
          ),

          // Select Your Own Map Button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.orangeStart,
                      AppColors.orangeEnd,
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ElevatedButton(
                  onPressed: () {
                    // Handle select own map
                    Get.to(() => DownloadMap());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'select_your_own_map'.tr,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),

          SizedBox(height: 20.h),
        ],
      ),
    );
  }

  Widget _buildMapCard(
    BuildContext context,
    ProfileController controller,
    Map<String, dynamic> map,
    int index,
  ) {
    return GestureDetector(
      onTap: () {
        // Navigate to view the selected map area
        _viewMapArea(controller, index);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    map['name'],
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    '${'last_download'.tr} ${map['lastDownloaded']}',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            PopupMenuButton<String>(
              icon: const Icon(
                Icons.more_vert,
                color: Colors.black,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'rename',
                  child: Row(
                    children: [
                      const Icon(
                        Icons.edit,
                        size: 20,
                        color: Colors.black,
                      ),
                      const SizedBox(width: 12),
                      Text('rename'.tr),
                    ],
                  ),
                ),

                PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      const Icon(
                        Icons.delete,
                        size: 20,
                        color: Colors.red,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'delete'.tr,
                        style: const TextStyle(
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              onSelected: (value) {
                if (value == 'rename') {
                  controller.showRenameDialog(context, index);
                } else if (value == 'delete') {
                  _showDeleteConfirmation(
                    context,
                    controller,
                    index,
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(
    BuildContext context,
    ProfileController controller,
    int index,
  ) {
    Get.dialog(
      AlertDialog(
        title: Text(
          'delete_map'.tr,
        ),
        content: Text(
          'are_you_sure_delete'.tr,
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'cancel'.tr,
            ),
          ),
          TextButton(
            onPressed: () {
              controller.deleteMap(index);
              Get.back();
            },
            child: Text(
              'delete'.tr,
              style: const TextStyle(
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _viewMapArea(
    ProfileController controller,
    int index,
  ) {
    if (index >= 0 && index < controller.downloadedMaps.length) {
      final map = controller.downloadedMaps[index];

      final mapName = map['name'];

      final lat =
          map['latitude'] ?? controller.initialLat;

      final lng =
          map['longitude'] ?? controller.initialLng;

      final zoom =
          map['zoom'] ?? 15.0;

      // Move camera to saved location
      controller.moveCamera(
        lat,
        lng,
        zoom: zoom,
      );

      // Navigate to ViewSavedMap screen to view the area
      // (without download button)
      Get.to(
        () => ViewSavedMap(
          mapName: mapName,
        ),
      );
    }
  }
}