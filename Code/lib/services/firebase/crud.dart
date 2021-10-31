import 'package:aadhaar_address_update/models/AddressModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:aadhaar_address_update/models/ProfileModel.dart';
import 'package:aadhaar_address_update/models/RequestModel.dart';
import 'package:aadhaar_address_update/models/DonorData.dart';

import 'package:uuid/uuid.dart';

class CRUD{
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static CollectionReference users = _firestore.collection("users");
  static CollectionReference audit = _firestore.collection("audit");

  static Future<bool> sendRequest(Profile profile, String phone) async{
    bool suc = await users.doc(profile.phone).set({'1': '1'}).then((value) => true);
    CollectionReference ref_donor = users.doc(profile.phone).collection('donors');
    bool res = await ref_donor.doc(phone)
        .set({
          "accept": false,
          "donoraddress": {},
          "name": profile.name
        }).then((value) => true);
    if(res){
      print('Successfully added in donor section');
    }


    CollectionReference ref_users  = FirebaseFirestore.instance.collection("users");
    bool suc2 = await ref_users.doc(phone).set({'1': '0'}).then((value) => true);
    CollectionReference ref_req = ref_users.doc(phone).collection('requests');
    bool res2 = await ref_req.doc(profile.phone).set({'1': '1'}).then((value) => true);
    if(res2){
      print('Updated in donors request section');
    }

    return true;
  }


  //If user sends any request
  static Future<Donor> checkRequest(String phone) async{
    CollectionReference ref_donor = users.doc(phone).collection('donors');
    QuerySnapshot donor = await ref_donor.get();
    List<QueryDocumentSnapshot> list = donor.docs;

    if(list.isEmpty){
      Address address = new Address(co: '', house: '', street: '', lm: '', loc: '', country: '', vtc: '', dist: '', state: '', pc: '');
      Donor d = new Donor(
          phone: '',
          accepted: false,
          address: address
      );
      return d;
    }else{
      DocumentSnapshot details = await ref_donor.doc(list[0].id).get();
      if(details['accept']){
        Address address = new Address(
            co: details['donoraddress']['co'],
            house: details['donoraddress']['house'],
            street: details['donoraddress']['street'],
            lm: details['donoraddress']['lm'],
            loc: details['donoraddress']['loc'],
            country: details['donoraddress']['country'],
            vtc: details['donoraddress']['vtc'],
            dist: details['donoraddress']['dist'],
            state: details['donoraddress']['state'],
            pc: details['donoraddress']['pc']
        );

        Donor d = new Donor(
            phone: list[0].id,
            accepted: details['accept'],
            address: address
        );

        return d;
      }else{
        Address address = new Address(co: '', house: '', street: '', lm: '', loc: '', country: '', vtc: '', dist: '', state: '', pc: '');
        Donor d = new Donor(
            phone: list[0].id,
            accepted: details['accept'],
            address: address
        );

        return d;
      }
    }
  }

  static Future<void> cancelRequest(String phone, String donor_number, bool store) async{
    await users.doc(phone).collection('donors').doc(donor_number).delete();

    await users.doc(donor_number).collection('requests').doc(phone).delete();

    if(store){
      var uuid = Uuid();

      await audit.doc(uuid.v4()).set({
        'user': phone,
        'donor': donor_number,
        'status': 'declined'
      });
      print('Audited');
    }
  }

  static Future<void> acceptRequest(String donor_number, String phone, Address address) async{
    await users.doc(phone).collection('donors').doc(donor_number).update({
      'accept': true,
      'donoraddress': address.toJson()
    });

    await users.doc(donor_number).collection('requests').doc(phone).delete();
  }

  static Future<void> removeAndUpdateAudit(String phone, Donor donor, Address address) async{
    var uuid = Uuid();

    await audit.doc(uuid.v4()).set({
      'user': phone,
      'donor': donor.phone,
      'donor_address': donor.address.toJson(),
      'updated_address': address.toJson()
    });
    print('Audited');

    await users.doc(phone).collection('donors').doc(donor.phone).delete();
  }


  static Future<List<Request>> receiveRequests(String phone) async{
    QuerySnapshot request = await users.doc(phone).collection('requests').get();
    List<QueryDocumentSnapshot> list = request.docs;

    List<Request> requests = [];

    for(QueryDocumentSnapshot l in list){
      String phone_number = l.id;

      DocumentSnapshot details = await users.doc(phone_number).collection('donors').doc(phone).get();
      Request req = new Request(
          name: details['name'],
          phone: phone_number
      );

      requests.add(req);
    }

    return requests;
  }
}