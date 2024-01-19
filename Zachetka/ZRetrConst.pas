unit ZRetrConst;

interface

Const
  ZRS_MAX_DEV     = 8;
  ZRS_SEARCH_PORT = 9000;
  ZRS_SEARCH_REQ  = 'SEEK Z397IP';

Type
  TZDev_Type = (
    ZDT_UNDEF = 0,
    ZDT_Z397,         // Z-397
    ZDT_Z397_G_NORM,  // Z-397 Guard � ������ "Normal"
    ZDT_Z397_G_ADV,   // Z-397 Guard � ������ "Advanced"
    ZDT_Z2U,          // Z-2 USB
    ZDT_M3A,          // Matrix III Rd-All
    ZDT_Z2M,          // Z-2 USB MF
    ZDT_M3N,          // Matrix III Net
    ZDT_CPZ2MF,       // CP-Z-2MF
    ZDT_Z2EHR         // Z-2 EHR
  );

implementation

end.
