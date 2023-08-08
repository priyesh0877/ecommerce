import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class prodetails extends StatefulWidget {
  Map m;
  prodetails(this.m);

  @override
  State<prodetails> createState() => _prodetailsState();
}

class _prodetailsState extends State<prodetails> {
  List<String> image = [];
  int _counter = 0;
  double real=0;
  double last=0;
  double review = 0;

  void initState() {
    // TODO: implement initState
    super.initState();
    review = widget.m['rating'];
    image = List<String>.from(widget.m['images']);
    real=double.parse(widget.m['price'].toString())*double.parse(widget.m['discountPercentage'].toString())/100;

    last=widget.m['price']-real;
    print(last);
  }
  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          body: Container(
            margin: EdgeInsets.all(10),
            height: double.infinity,
            width: double.infinity,
            child: Column(children: [
              Text("${widget.m['title']}",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
              Row(
                children: [
                  RatingBar.builder(
                    initialRating: review,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder: (context, _) => Icon(
                      Icons.star_border_purple500,
                      color: Colors.tealAccent.shade700,
                    ),
                    onRatingUpdate: (rating) {
                      print(rating);
                    },
                  ),
                  Text("($review Reviews)"),
                ],
              ),
              CarouselSlider(
                options: CarouselOptions(height: 400.0),
                items: image.map((i) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.symmetric(horizontal: 5.0),
                          child: Image(image: NetworkImage(i)));
                    },
                  );
                }).toList(),
              ),
              Row(
                children: [
                  Text("${widget.m['price']}€",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                  Text("(${widget.m['discountPercentage']}%)",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  Text(" $last€",
                      style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold, fontSize: 30)),
                ],
              ),
              SizedBox(height: 20,),
              Text("${widget.m['description']}"),
              SizedBox(height: 20,),
              Row(
                children: [
                  Text("on stock = ${widget.m['stock']}",style: TextStyle(fontSize: 20)),
                ],
              ),
              ElevatedButton(onPressed: (){
                Razorpay razorpay = Razorpay();
                var options = {
                  'key': 'rzp_test_pFO8fM6KRdgkkz',
                  'amount': widget.m['price']*100,
                  'name': widget.m['title'],
                  'description': widget.m['category'],
                  'retry': {'enabled': true, 'max_count': 1},
                  'send_sms_hash': true,
                  'prefill': {'contact': '9558195936', 'email': 'test@  razorpay.com'},
                  'external': {'wallets': ['paytm']}
                };
                razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentErrorResponse);
                razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccessResponse);
                razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWalletSelected);
                razorpay.open(options);
              },
                  child: Text("Pay now")),
            ],
            ),
          ),
          // This trailing comma makes auto-formatting nicer for build methods.
        ));

  }

  void handlePaymentErrorResponse(PaymentFailureResponse response){
    /*
    * PaymentFailureResponse contains three values:
    * 1. Error Code
    * 2. Error Description
    * 3. Metadata
    * */
    showAlertDialog(context, "Payment Failed", "Code: ${response.code}\nDescription: ${response.message}\nMetadata:${response.error.toString()}");
  }

  void handlePaymentSuccessResponse(PaymentSuccessResponse response){
    /*
    * Payment Success Response contains three values:
    * 1. Order ID
    * 2. Payment ID
    * 3. Signature
    */
    showAlertDialog(context, "Payment Successful", "Payment ID: ${response.paymentId}");
  }

  void handleExternalWalletSelected(ExternalWalletResponse response){
    showAlertDialog(context, "External Wallet Selected", "${response.walletName}");
  }

  void showAlertDialog(BuildContext context, String title, String message){
    // set up the buttons
    Widget continueButton = ElevatedButton(
      child: const Text("Continue"),
      onPressed:  () {
        Navigator.pop(context);
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
} 