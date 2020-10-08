UPI: Unified Payments Interface

developed by NPCI (national payments corporation of India), regulated by RBI(Reserve Bank of India)
used for P2P or P2M payments each person/merchant has a VPA (Virtual private address)

all payments service provider/PSP (mostly banks) are directly connected to NPCI

VPA / UPI-id is a email like identifier ex: user@bank, in this the first part is user identifier and the second part is the PSP identifier

works 24/7

2factor auth is mandetory, 1st the OTP and 2nd the mPIN.

payments possisble - 

VPA to VPA
		mobile no
		AccountNo and IFSC / MMID (mobile money identifer - 7digit code)
		Aadhar
		QR code

transation limit:
	20 transations a day
	each transation cannot exceed 20000 and max 1 lakh per day transfer

UPI is based on IMPS and it is based on NFS (national financial switch)

APIs are done using XML over HTTPS whereas all APIs behind the existing systems at NPCI are done over ISO 8583 Messages (0200/0210).
