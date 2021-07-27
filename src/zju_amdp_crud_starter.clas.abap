CLASS zju_amdp_crud_starter DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES: if_oo_adt_classrun.

  PROTECTED SECTION.
  PRIVATE SECTION.

    CLASS-METHODS insert_data.
ENDCLASS.



CLASS zju_amdp_crud_starter IMPLEMENTATION.



  METHOD if_oo_adt_classrun~main.

   DATA lt_preise TYPE SORTED TABLE OF zju_preise WITH UNIQUE KEY laenge breite hoehe gewicht als_paeckchen ist_online.
    zju_amdp_crud_starter=>insert_data( ).

    COMMIT WORK AND WAIT.
    SELECT * FROM zju_preise INTO CORRESPONDING FIELDS OF TABLE @lt_preise.

    out->write( lt_preise ).

  ENDMETHOD.
  METHOD insert_data.

    DATA lt_preise TYPE SORTED TABLE OF zju_preise WITH UNIQUE KEY laenge breite hoehe gewicht als_paeckchen ist_online.

    lt_preise = VALUE #( ( laenge = 30  breite = 30  hoehe = 30 gewicht = 1000 als_paeckchen = 'X'  ist_online = 'X' preis = 389 )
                         ( laenge = 30  breite = 30  hoehe = 30 gewicht = 1000 als_paeckchen = 'X'  ist_online = ' ' preis = 400 )
                         ( laenge = 60  breite = 30  hoehe = 30 gewicht = 1000 als_paeckchen = 'X'  ist_online = 'X' preis = 439 )
                         ( laenge = 60  breite = 30  hoehe = 15 gewicht = 1000 als_paeckchen = 'X'  ist_online = ' ' preis = 450 )
                         ( laenge = 60  breite = 30  hoehe = 15 gewicht = 2000 als_paeckchen = ' '  ist_online = 'X' preis = 499 )
                         ( laenge = 60  breite = 30  hoehe = 15 gewicht = 2000 als_paeckchen = ' '  ist_online = ' ' preis = 699 )
                         ( laenge = 61  breite = 30  hoehe = 15 gewicht = 2000 als_paeckchen = ' '  ist_online = 'X' preis = 599 )
                         ( laenge = 60  breite = 30  hoehe = 30 gewicht = 10001 als_paeckchen = ' '  ist_online = 'X' preis = 1649 )
                         ( laenge = 120  breite = 60  hoehe = 60 gewicht = 2000 als_paeckchen = ' '  ist_online = 'X' preis = 1649 )
                         ( laenge = 60  breite = 30  hoehe = 15 gewicht = 2001 als_paeckchen = ' '  ist_online = 'X' preis = 499 )
                         ( laenge = 61  breite = 30  hoehe = 15 gewicht = 2000 als_paeckchen = ' '  ist_online = ' ' preis = 699 )
                         ( laenge = 60  breite = 30  hoehe = 30 gewicht = 10001 als_paeckchen = ' '  ist_online = ' ' preis = 1649 )
                         ( laenge = 120  breite = 60  hoehe = 60 gewicht = 2000 als_paeckchen = ' '  ist_online = ' ' preis = 1649 )
                         ( laenge = 60  breite = 30  hoehe = 15 gewicht = 10000 als_paeckchen = ' '  ist_online = ' ' preis = 949 )
                         ( laenge = 60  breite = 30  hoehe = 15 gewicht = 40000 als_paeckchen = ' '  ist_online = ' ' preis = 0 )
                         ( laenge = 60  breite = 30  hoehe = 15 gewicht = 3000 als_paeckchen = 'X'  ist_online = 'X' preis = 0 )
                         ( laenge = 121  breite = 60  hoehe = 60 gewicht = 2000 als_paeckchen = ' '  ist_online = ' ' preis = 0 )
    ).

    DELETE zju_preise FROM TABLE @lt_preise.
    insert zju_preise FROM TABLE @lt_preise.

  ENDMETHOD.

ENDCLASS.
