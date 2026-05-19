string GetCurrencyByEvent(const MqlCalendarEvent &event)
{
   MqlCalendarCountry country;
   
   // Informationen zum Land anhand der ID abrufen
   if(CalendarCountryById(event.country_id, country))
   {
      return country.currency; // Hier steht dann z.B. "USD", "EUR", "JPY"
   }
   
   return ""; // Falls nichts gefunden wurde
}