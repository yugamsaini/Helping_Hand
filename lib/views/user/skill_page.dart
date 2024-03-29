import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:helping_hand/models/user.dart' as model;
import 'package:helping_hand/providers/user_provider.dart';
import 'package:helping_hand/widgets/skill_card.dart';
import 'package:helping_hand/widgets/utils.dart';
import 'package:helping_hand/widgets/my_button.dart';
import 'package:provider/provider.dart';

class SkillPage extends StatefulWidget {

  const SkillPage({super.key});

  @override
  State<SkillPage> createState() => _SkillPageState();
}

class _SkillPageState extends State<SkillPage> {
  List<String> skills = [];
  

  @override
  Widget build(BuildContext context) {
    model.User user = Provider.of<UserProvider>(context, listen: false).getUser;
    Map<String, dynamic> userMap = user.getData();
    String id = userMap['uid'];
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Center(
        child: SafeArea(
          child: Column(
            children: [
               SizedBox(height: height * 0.05,),
              const Text('Select your Skills', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Color(0xff323459)),),
              SizedBox(height: height * 0.005,),
              const Text('You can choose multiple categories', style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),),
               SizedBox(height: height * 0.02,),
              Container(
                height: height * 0.57,
                child: GridView.builder(
                  padding: const EdgeInsets.all(15),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: cardList.length,
                  itemBuilder: (BuildContext context, int index){
                    return SkillCard(text: skillCard[index].text, icon: skillCard[index].icon, size: skillCard[index].size, list: skills,);
                  }
                ),
              ),
              //continue button
              SizedBox(height: height * 0.02,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: MyButton(onTap: () async {
                  //print(skills);
                  String res = 'no';
                  if(skills.isNotEmpty){
                    await FirebaseFirestore.instance.collection("users").doc(id).update({"skills":skills});
                    res = 'done';
                  }
                  
                  //showErrorMessage('you skill were updated..');
                  Navigator.pop(context, res);
                }, text: 'Continue', color: const Color(0xff6379A5),),
              ),

              //skip button
               SizedBox(height: height * 0.02,),
              GestureDetector(
                onTap: (){
                  Navigator.pop(context);
                },
                child: Container(
                  padding: const EdgeInsets.all(25),
                  margin: const EdgeInsets.symmetric(horizontal: 25),
                  decoration: BoxDecoration( borderRadius: BorderRadius.circular(50), border: Border.all(color: const Color(0xffBBBBD6))),
                  child: const Center(
                    child: Text('Skip', style: TextStyle(color: Color.fromARGB(255, 144, 144, 151), fontWeight: FontWeight.bold, fontSize: 16),),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}