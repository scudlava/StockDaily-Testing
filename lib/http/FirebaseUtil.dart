import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myfinancial/model/company.dart';
import 'package:myfinancial/model/user_account.dart';
import 'package:myfinancial/util/util.dart';

class FirebaseUtil{
  
  static void followCompany(Company company) async{
    UserAccount user = await UserProfile.fetch();
    CollectionReference companyRef = FirebaseFirestore.instance.collection('users').doc(user.id).collection('listfollow');
    companyRef
        .add({
      "symbol": company.symbol,
      "simpleName": company.simpleName,
      "country": company.country,
      "icon": company.icon,
      "name": company.name
    })
        .then((value) {

    }
    );
    }

  static void unFollowCompany(Company company) async{
    UserAccount user = await UserProfile.fetch();
    CollectionReference companyRef = FirebaseFirestore.instance.collection('users').doc(user.id).collection('listfollow');
    print('SymbolFollow is : ${company.symbol}');
    companyRef.where('symbol', isEqualTo: company.symbol).snapshots().listen(
            (data) {
              if(data.docs!=null) {
                if (data.docs.isNotEmpty) {
                  // print('data is : ${data.docs.length}');
                  // data.docs[0]
                  // FirebaseFirestore.instance.collection(collectionPath)
                  companyRef.doc(data.docs[0].id).delete();
                }
              }
            });
  }

}