export const createPaymentIntention = async ({ amount, currency = 'EGP', billingData, orderId }) => {
    try {
        const amountCents = amount > 0 ? Math.round(amount * 100) : 1000; // default 10 EGP if 0

        // 1. Authentication Request
        const authResponse = await fetch('https://accept.paymob.com/api/auth/tokens', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ api_key: process.env.PAYMOB_API_KEY })
        });
        const authData = await authResponse.json();
        if (!authResponse.ok) throw new Error('Paymob Auth Error: ' + authData.message);
        const authToken = authData.token;

        // 2. Order Registration
        const orderResponse = await fetch('https://accept.paymob.com/api/ecommerce/orders', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({
                auth_token: authToken,
                delivery_needed: "false",
                amount_cents: amountCents,
                currency,
                merchant_order_id: String(orderId)
            })
        });
        const orderData = await orderResponse.json();
        if (!orderResponse.ok) throw new Error('Paymob Order Error: ' + orderData.message);
        const paymobOrderId = orderData.id;

        // 3. Payment Key Request
        const paymentKeyResponse = await fetch('https://accept.paymob.com/api/acceptance/payment_keys', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({
                auth_token: authToken,
                amount_cents: amountCents,
                expiration: 3600,
                order_id: paymobOrderId,
                billing_data: {
                    first_name: billingData.first_name || 'NA',
                    last_name: billingData.last_name || 'NA',
                    email: billingData.email || 'NA@example.com',
                    phone_number: billingData.phone_number || '+201000000000',
                    apartment: 'NA',
                    floor: 'NA',
                    street: 'NA',
                    building: 'NA',
                    city: 'NA',
                    country: 'EG',
                    state: 'NA'
                },
                currency,
                integration_id: process.env.PAYMOB_INTEGRATION_ID
            })
        });
        const paymentKeyData = await paymentKeyResponse.json();
        if (!paymentKeyResponse.ok) throw new Error('Paymob Payment Key Error: ' + paymentKeyData.message);
        const paymentToken = paymentKeyData.token;

        // The checkout URL requires an iframe ID. If you have it, replace YOUR_IFRAME_ID
        const checkoutUrl = `https://accept.paymob.com/api/acceptance/iframes/1006562?payment_token=${paymentToken}`;

        return { clientSecret: paymentToken, checkoutUrl, intentionId: paymobOrderId };
    } catch (error) {
        console.error('Payment Error:', error);
        throw error;
    }
};
