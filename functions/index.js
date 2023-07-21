const functions = require("firebase-functions");
const stripe = require("stripe")("sk_test_51NOUlkG7VB2W7Zzqa9R41MGdjwjOOzl1j5ceZQ7htoe275gHeeDVvryFqDO5Jx8KowpiRUX9fDzjlboVaXYGVAF1002ZLAEbds");

exports.stripePaymentIntentRequest = functions.https.onRequest(async (req, res) => {
    try {
        let customerId;

        //Gets the customer who's email id matches the one sent by the client
        const customerList = await stripe.customers.list({
            email: req.body.email,
            limit: 1
        });
                
        //Checks the if the customer exists, if not creates a new customer
        if (customerList.data.length !== 0) {
            customerId = customerList.data[0].id;
        }
        else {
            const customer = await stripe.customers.create({
                email: req.body.email,
                name : req.body.name,
                name : req.body.id,
            });
            customerId = customer.data.id;
        }

        //Creates a temporary secret key linked with the customer 
        const ephemeralKey = await stripe.ephemeralKeys.create(
            { customer: customerId },
            { apiVersion: '2022-11-15' }
        );

        //Creates a new payment intent with amount passed in from the client
        const paymentIntent = await stripe.paymentIntents.create({
            amount: parseInt(req.body.amount),
            currency: 'mxn', 
            customer: customerId,
            automatic_payment_methods: {
                enabled: true,
              },
        })
        res.status(200).send({
            paymentIntent: paymentIntent.client_secret,
            ephemeralKey: ephemeralKey.secret,
            customer: customerId,
            success: true,
        })
        
    } catch (error) {
        res.status(404).send({ success: false, error: error.message })
    }
});