// import 'package:flutter_stripe/flutter_stripe.dart';

// class PaymentService {
//   final int amount;
//   final String url;

//   PaymentService({
//     this.amount = 10,
//     this.url = "",
//   });

//   static init() {
//     StripePayment.setOptions(
//       StripeOptions(
//         publishableKey:
//             "INSERT YOUR KEy",
//         androidPayMode: "test",
//         merchantId: "test",
//       ),
//     );
//   }

//   Future<PaymentMethod> addPaymentMethod() async {
//     print("thi ssi is $amount");

//     PaymentMethod paymentMethod =
//         await StripePayment.paymentRequestWithCardForm(
//       CardFormPaymentRequest(),
//     );
//     return paymentMethod;
//   }
// }
