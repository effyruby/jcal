unit JCalConstants;

interface

uses  DHPRecord,
      JCalTypes,
      AlephBet,
      MILON;

const
  YC1Digits: array[0..3] of string=
    (BAIS,GIMEL,HEY,ZAYIN);
//    ('2','3','5','7');
  YC2Digits: array[0..7] of string=
    ('2d','2a','3r','5d','5r','5a','7d','7a');
  YC3Digits: array[0..13] of string=
    ('2d3','2a5','3r5','5r7','5a1','7d1','7a3',
      '2D5','2A7','3R7','5D1','5A3','7D3','7A5');

  TRegularHebMonths: array[0..11] of string=(
    TISHREI,  //Tishrei
    CHESVAN,  //Cheshvan
    KISLEV,  //Kisleb
    TEVES,  //TEVES
    SHEVOT, //SHEVOT
    ADAR, //Adar
    NISSAN, //Nissan
    IYAR, //Iyar
    SIVAN, //Sivan
    TAMMUZ, //Tammuz
    OV,   //OV
    ELUL  //Elul
    );

  TLeapHebMonths: array[0..12] of string=(
    TISHREI,  //Tishrei
    CHESVAN,  //Cheshvan
    KISLEV,  //Kisleb
    TEVES,  //TEVES
    SHEVOT, //SHEVOT
    ADARALEPH, //Adar Aleph
    ADARBAIS, //Adar Baid
    NISSAN, //Nissan
    IYAR, //Iyar
    SIVAN, //Sivan
    TAMMUZ, //Tammuz
    OV, //OV
    ELUL  //Elul
    );

  DaysOfWeek: array[0..6] of string=
  ('Shabbos', 'Sunday','Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday');

  HebMonths: array[1..12] of TMonth=
  ((Month: 'January'; Days: 31),
   (Month: 'February'; Days: 28),
   (Month: 'March'; Days: 31),
   (Month: 'April'; Days: 30),
   (Month: 'May'; Days: 31),
   (Month: 'June'; Days: 30),
   (Month: 'July'; Days: 31),
   (Month: 'August'; Days: 31),
   (Month: 'September'; Days: 30),
   (Month: 'Octoner'; Days: 31),
   (Month: 'November'; Days: 30),
   (Month: 'December'; Days: 31));

// Tekufa Constants
//  BaseTekufa: TDHP=
//   (Day: -12; Hour: -20; Part: -204);
  OneTekufaCycle: TDHP=
   (Day: 0; Hour: 1; Part: 485);
  OneRegularTekufaCycle: TDHP=
   (Day: 10; Hour: 21; Part: 204);
  OneLeapTekufaCycle: TDHP=
   (Day: 21; Hour: 9; Part: 491);

// Molad Constants
  OneCycle: TDHP=
   (Day: 2; Hour: 16; Part: 595);
  RegularYear: TDHP=
   (Day: 4; Hour: 8; Part: 876);
  LeapYear: TDHP=
   (Day: 5; Hour: 21; Part: 589);
  BaseYear: TDHP=
   (Day: 2; Hour: 5; Part: 204);
  OneMonth: TDHP=       //AddHebDates
   (Day: 1; Hour: 12; Part: 793);


implementation

end.
