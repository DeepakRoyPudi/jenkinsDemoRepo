public class TestDataFactory {
    public static List<Order> createOrderTestRecord (Integer numberOfRecords, String Name) {
        Account objAccount = new Account(name = 'Eternus');
        insert objAccount;
        List<Order> listOrder = new List<Order>();
        for(integer indexI = 0; indexI < numberOfRecords; indexI++) {
            Order objOrder = new Order(Name = Name + 'indexI',
                                       EffectiveDate = system.today(),
                                       AccountId = objAccount.Id,
                                       Status = 'Draft'
                                      );
            listOrder.add(objOrder);
        }
        return listOrder;
    }
    
    public static List<QuoteLineItem> createQuoteLineItemTestRecord (Integer numberOfRecords, String Name) {
                
        Opportunity objOpportunity = new Opportunity(name = 'rahim',
                                                     StageName = 'Open',
                                                     CloseDate = system.today()
                                                     //PriceBook2Id = Test.getStandardPricebookId()
                                                    );
        insert objOpportunity;
        Product2 objProduct2 = new Product2(Name = 'PRODUCT_NAME');
        insert objProduct2;

        PricebookEntry objPriceBookEntry = New PricebookEntry(Product2Id=objProduct2.Id,
                                                PriceBook2Id = Test.getStandardPricebookId(),
                                                unitPrice = 444.0,
                                                isactive = true
                                               );
        insert objPriceBookEntry;
        
        Quote objQuote = new Quote(Name = 'Eternus',
                                   OpportunityId = objOpportunity.Id,
                                   pricebook2id=Test.getStandardPricebookId()
                                  );
        insert objQuote;
        List<QuoteLineItem> listQuoteLineItem = new List<QuoteLineItem>();
        for(integer indexI = 0; indexI < numberOfRecords; indexI++) {
            QuoteLineItem objQuoteLineItem = new QuoteLineItem(QuoteId = objQuote.Id,
                                                               UnitPrice = 10,
                                                               Discount = 10,
                                                               Quantity = 10,
                                                               pricebookentryid = objPriceBookEntry.id
                                                              );
            listQuoteLineItem.add(objQuoteLineItem);
        }
        return listQuoteLineItem;
    }

}