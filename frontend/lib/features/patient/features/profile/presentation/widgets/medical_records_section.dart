import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:medi/core/core.dart';

class MedicalRecordsSection extends StatelessWidget {
  const MedicalRecordsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding:  EdgeInsets.all(AppSizes.w24),
        child: Column(
          children: [
            Row(
              children: [
                SvgPicture.asset(AppAssets.stethoscope,width: 24,height: 24,),
                SizedBox(width: 8),
                Text("Medical Records",style:AppStyles.black18500 ,),
            ],
          ),
          SizedBox(height: 20),
         ListTile(
          contentPadding: EdgeInsets.zero,
           title: Text("Daily symptoms",style: AppStyles.black16400,),
           trailing: Icon(Icons.arrow_forward_ios,color: AppColors.primary,),
         ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text("Export health report",style: AppStyles.black16400,),
            trailing: SvgPicture.asset(AppAssets.export,width: 24,height: 24,),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text("Export health passport",style: AppStyles.black16400,),
            trailing: SvgPicture.asset(AppAssets.export,width: 24,height: 24,),
          ),
          
          
         
        ],
        ),
      )
    );
  }
}