
const functions = require("firebase-functions");
const admin = require("firebase-admin");


admin.initializeApp();

const stripe = require("stripe")("sk_test_51PQ2iD00So438Qdez2W3OxQsgvliHgcev9d6CNB05iHytcE678khq6B40NNn6QAQwsmLSBtjjBBdSijXzxStN1bU00t67gL9SJ");


exports.initPaymentSheet = functions.https.onRequest(async (data, res) => {
  try {
    const {amount, customerId} = data.body;

    console.log(amount);
    console.log(customerId);
    const ephemeralKey = await stripe.ephemeralKeys.create({
      customer: customerId,
    }, {
      apiVersion: "2024-04-10",
    });
    console.log(ephemeralKey.secret);


    const paymentIntent = await stripe.paymentIntents.create({
      amount: amount,
      currency: "usd",
      customer: customerId,
      automatic_payment_methods: {
        enabled: true,
      },
    });
    console.log(paymentIntent.client_secret);

    res.status(200).json({
      paymentIntent: paymentIntent,
      ephemeralKey: ephemeralKey.secret,
      customer: customerId,
      clientSecret: paymentIntent.client_secret,
    });
  } catch (error) {
    console.error("Error:", error.message);
    res.status(500).json({error: error.message});
  }
});

exports.createStripeCustomer = functions.https.onRequest(async (data, res) => {
  try {
    const email = data.body.email;
    const customer = await stripe.customers.create({
      email: email,
    });

    res.json({customerId: customer.id});
  } catch (err) {
    console.log(err);
    res.json({error: err});

    res.status(500).json({error: err.message});
  }
});
