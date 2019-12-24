/**
 * @author      Pawel Wozniak p.wozniak@instamotion.com
 * @created     2018-08-24
 * @updated     2019-11-28
 * @description Use this constants in code instead of string values. 
  In case of String change it will be done only here.
*/

public class Constants {

    // Product2.Family
    public static final String PRODUCT2_FAMILY_ACCESSORY = 'Zubehör';
    public static final String PRODUCT2_FAMILY_BDK_EXCHANGE = 'BDK-Ankauf';
    public static final String PRODUCT2_FAMILY_COMMISSION = 'Commission';
    public static final String PRODUCT2_FAMILY_FLASH_SALE = 'Flash';
    public static final String PRODUCT2_FAMILY_VOUCHER = 'Gutschein';
    public static final String PRODUCT2_FAMILY_USED_CAR = 'Gebrauchtfahrzeug';
    public static final String PRODUCT2_FAMILY_INSURANCE = 'Insurance';

    // Opportunity.RecordTypeName
    public static final String OPP_RT_NAME_ACTION = 'Aktion';
    public static final String OPP_RT_NAME_B2B_OPPORTUNITY = 'B2B Opportunity';
    public static final String OPP_RT_NAME_DIRECT_ORDER = 'Direktbestellung';
    public static final String OPP_RT_NAME_EMAIL = 'Email';
    public static final String OPP_RT_NAME_INTEREST_IN_BUYING = 'Fahrzeuginteresse';
    public static final String OPP_RT_NAME_IM_PRIME = 'InstaMotion Prime';
    public static final String OPP_RT_NAME_TRADE_IN = 'Inzahlungnahme';
    public static final String OPP_RT_NAME_EXCHANGE_AF24 = 'Inzahlungnahme-AF24';
    public static final String OPP_RT_NAME_QUERY = 'Suchanfrage';
    public static final String OPP_RT_NAME_YALLOTRADE = 'Yallotrade';

    // Opportunity.Type
    public static final String OPP_TYPE_CAR_EXCHANGE = 'Inzahlungnahme';

    // Opportunity.StageName
    public static final String OPP_STAGE_QUALIFICATION = 'Qualifikation';
    public static final String OPP_STAGE_PREQUALI1 = 'Pre-Qualification I';
    public static final String OPP_STAGE_PREQUALI2 = 'Pre-Qualification II';
    public static final String OPP_STAGE_PREQUALI3 = 'Pre-Qualification III';
    public static final String OPP_STAGE_PREQUALI4 = 'Pre-Qualification IV';
    public static final String OPP_STAGE_CONSULTATION = 'Beratung';
    public static final String OPP_STAGE_NEGOTIATION = 'Verhandlung';
    public static final String OPP_STAGE_WAITING_FOR_CONFIRMATION = 'Warten auf Bestätigung';
    public static final String OPP_STAGE_BANK = 'Bank';
    public static final String OPP_STAGE_VERIFICATION_EXPERTISE = 'Verf./Gutachten';
    public static final String OPP_STAGE_CLOSED_WON = 'Closed Won';
    public static final String OPP_STAGE_CLOSED_LOST = 'Closed Lost';

    // Opportunity.Call_Center_Feedback__c
    public static final String OPP_CALL_CENTER_FEEDBACK_NOT_REACHED = 'Kunden nicht erreicht';
    public static final String OPP_CALL_CENTER_FEEDBACK_CUSTOMER_SENT_NEW_REQUEST = 'Kunde hat neue Anfrage erstellt';

    // Opportunity.IM_Feedback__c
    public static final String OPP_IM_FEEDBACK_NOT_REACHED = 'Kunde nicht erreicht';

    // Opportunity.IM_Not_reached__c
    public static final String OPP_IM_NOT_REACHED_1ST_ATTEMPT = '1 Versuch';

    // Opportuniry.Financing__c
    public static final String OPP_FINANCING_BANK11_OFFLINE = 'Bank11/Offline';
    public static final String OPP_FINANCING_BANK11_ONLINE = 'Bank11/Online';
    public static final String OPP_FINANCING_BANK11_SEMI = 'Bank11/Semi';
    public static final String OPP_FINANCING_BANKTRANSFER = 'Überweisung/Rechnung';
    public static final String OPP_FINANCING_LEASING = 'Leasing';
    public static final String OPP_CLONED = 'Opportunity Cloned';


    // Lead.Status
    public static final String LEAD_STATUS_NEW = 'New';
    public static final String LEAD_STATUS_QUALIFICATION = 'Qualification';
    public static final String LEAD_STATUS_CALL_1 = 'Call 1';
    public static final String LEAD_STATUS_CALL_2 = 'Call 2';
    public static final String LEAD_STATUS_MAIL_1 = 'Mail 1';
    public static final String LEAD_STATUS_PREQUALI1 = 'Pre-Qualification I';
    public static final String LEAD_STATUS_PREQUALI2 = 'Pre-Qualification II';
    public static final String LEAD_STATUS_PREQUALI3 = 'Pre-Qualification III';
    public static final String LEAD_STATUS_PREQUALI4 = 'Pre-Qualification IV';
    public static final String LEAD_STATUS_CONVERTED = 'Converted';
    public static final String LEAD_STATUS_CLOSED_LOST = 'Closed Lost';

    // Lead.Call_Center_Feedback__c
    public static final String LEAD_CC_FEEDBACK_1_CONTACT_ATTEMP = '1 Kontaktversuch';
    public static final String LEAD_CC_FEEDBACK_CUSTOMER_SENT_NEW_REQUEST = 'Kunde hat neue Anfrage erstellt';

    // CheckoutOrder__c.Order_status__c
    public static final String CO_ORDER_STATUS_NEW = 'Neu';
    public static final String CO_ORDER_STATUS_FZG_ORDER = 'FZG-Bestellung';
    public static final String CO_ORDER_STATUS_PROFORMA_ISSUED = 'Proforma';
    public static final String CO_ORDER_STATUS_INVOICE_ISSUED = 'Rechnung';
    public static final String CO_ORDER_STATUS_INVOICE_PAID = 'Zahlungseingang'; // ?
    public static final String CO_ORDER_STATUS_VEHICLE_PURCHASE = 'Fahrzeugeinkauf'; // ?
    public static final String CO_ORDER_STATUS_IN_DELIVERY = 'Auslieferung';
    public static final String CO_ORDER_STATUS_14_DAYS = '14 Tage';
    public static final String CO_ORDER_STATUS_PAYMENT_DELAYED = 'Zahlungsverzug';
    public static final String CO_ORDER_STATUS_ORDER_FINALIZED = 'Geschlossen';
    public static final String CO_ORDER_STATUS_CANCELED = 'Storniert';

    // CheckoutOrder__c.Payment_Type__c
    public static final String CO_ORDER_PAYMENT_TYPE_CASCH = 'Überweisung/Rechnung';

    // CheckoutOrder__c.Delivery_Partner__c
    public static final String CO_ORDER_DELIVERY_PARTNER_CAR_CONTROLLING = 'Car Controlling';
    public static final String CO_ORDER_DELIVERY_PARTNER_DAD = 'DAD';
    public static final String CO_ORDER_DELIVERY_PARTNER_HARTMANN = 'Hartmann';

    // Task.Status
    public static final String TASK_STATUS_OPEN = 'Offen';
    public static final String TASK_STATUS_CLOSED = 'Abgeschlossen';

    // Account.Type
    public static final String ACCOUNT_TYPE_POTENTIAL_CUSTOMER = 'Potenzieller Kunde';
    public static final String ACCOUNT_TYPE_CUSTOMER_FROM_CHECKOUT = 'Kunde von Checkout';

    // Account.Salutation
    public static final String ACCOUNT_SALUTATION_MR = 'Herr';
    public static final String ACCOUNT_SALUTATION_MS = 'Frau';

    // Commision
    public static final String COMMISSION_STATUS_PENDING = 'Pending';
    public static final String COMMISSION_STATUS_VALID = 'Valid';
    public static final String COMMISSION_STATUS_INVALID = 'Invalid';
    public static final String COMMISSION_STATUS_PAID = 'Paid';
    public static final String COMMISSION_STATUS_CLAWBACK = 'Clawback';


    // Global Picklists
    public static final String TYRES_TYPE_WINTER_TYRES = 'Winter tyres';

    // other
    public static final String NEW_LINE = '\r\n';

}