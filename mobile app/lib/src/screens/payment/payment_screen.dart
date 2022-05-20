// import 'package:flutter/material.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';

// class PaymentScreen extends StatelessWidget {
//   const PaymentScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(),
//       body: Column(children: [
//         CardField(
//           onCardChanged: (card) {
//             print(card);
//           },
//         ),
//         TextButton(
//           onPressed: () async {
//             await Stripe.instance
//                 .createPaymentMethod(const PaymentMethodParams.card());
//           },
//           child: const Text("Pay"),
//         )
//       ]),
//     );
//   }
// }
