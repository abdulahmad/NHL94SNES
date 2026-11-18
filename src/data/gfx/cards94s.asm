; Player photos: one macro per photo, each a label (Card001 ... Card156) with its packed 6 x 6 linear 4bpp tiles for DecompressHuffman.
; The photos sit in ROM among songs and samples, so the bank files expand them in ROM order: %Card001() puts one at the current address.
; The label is defined where the macro is expanded. The PlayerPhotoTable in bank $9D points at them.

; Player photo 1 (PlayerPhotoTable OTT 0)
macro Card001()
Card001:							;a player photo: 6 x 6 linear 4bpp tiles packed for DecompressHuffman, one
									;entry of the per-team photo
			;   table in bank $9D (the first photo of the Ottawa team)
	db $30,$FB
	db $00,$04,$80
	incbin "../../../Extracted/data/gfx/PlayerCards/Card001.lin.huf":5..532
endmacro

; Player photo 2 (PlayerPhotoTable DET 3)
macro Card002()
Card002:							;a player photo: 6 x 6 linear 4bpp tiles packed for DecompressHuffman, one
									;entry of the photo table
			;   in bank $9D
	db $30,$FB
	db $00,$04,$80
	incbin "../../../Extracted/data/gfx/PlayerCards/Card002.lin.huf":5..541
	db $00
endmacro

; Player photo 3 (PlayerPhotoTable DAL 0)
macro Card003()
Card003:							;a player photo: 6 x 6 linear 4bpp tiles packed for DecompressHuffman, one
									;entry of the photo table
			;   in bank $9D
	db $30,$FB
	db $00,$04,$80
	incbin "../../../Extracted/data/gfx/PlayerCards/Card003.lin.huf":5..639
endmacro

; Player photo 4 (PlayerPhotoTable CGY 14; ASW 17)
macro Card004()
Card004:							;a player photo: 6 x 6 linear 4bpp tiles packed for DecompressHuffman, one
									;entry of the photo table
			;   in bank $9D
	db $30,$FB
	db $00,$04,$80
	incbin "../../../Extracted/data/gfx/PlayerCards/Card004.lin.huf":5..717
endmacro

; Player photo 5 (PlayerPhotoTable NYR 15; ASE 19)
macro Card005()
Card005:							;a player photo: 6 x 6 linear 4bpp tiles packed for DecompressHuffman, one
									;entry of the photo table
			;   in bank $9D
	db $30,$FB
	db $00,$04,$80
	incbin "../../../Extracted/data/gfx/PlayerCards/Card005.lin.huf":5..663
endmacro

; Player photo 6 (PlayerPhotoTable ANH 3)
macro Card006()
Card006:							;a player photo: 6 x 6 linear 4bpp tiles packed for DecompressHuffman, one
									;entry of the photo table
			;   in bank $9D
	db $30,$FB
	db $00,$04,$80
	incbin "../../../Extracted/data/gfx/PlayerCards/Card006.lin.huf":5..660
endmacro

; Player photo 7 (PlayerPhotoTable DET 12)
macro Card007()
Card007:							;a player photo: 6 x 6 linear 4bpp tiles packed for DecompressHuffman, one
									;entry of the photo table
			;   in bank $9D
	db $30,$FB
	db $00,$04,$80
	incbin "../../../Extracted/data/gfx/PlayerCards/Card007.lin.huf":5..658
endmacro

; Player photo 8 (PlayerPhotoTable TOR 11)
macro Card008()
Card008:							;a player photo: 6 x 6 linear 4bpp tiles packed for DecompressHuffman, one
									;entry of the photo table
			;   in bank $9D
	db $30,$FB
	db $00,$04,$80
	incbin "../../../Extracted/data/gfx/PlayerCards/Card008.lin.huf":5..657
endmacro

; Player photo 9 (PlayerPhotoTable FLA 7)
macro Card009()
Card009:							;a player photo: 6 x 6 linear 4bpp tiles packed for DecompressHuffman, one
									;entry of the photo table
			;   in bank $9D
	db $30,$FB
	db $00,$04,$80
	incbin "../../../Extracted/data/gfx/PlayerCards/Card009.lin.huf":5..652
endmacro

; Player photo 10 (PlayerPhotoTable QUE 16)
macro Card010()
Card010:							;a player photo: 6 x 6 linear 4bpp tiles packed for DecompressHuffman, one
									;entry of the photo table
			;   in bank $9D
	db $30,$FB
	db $00,$04,$80
	incbin "../../../Extracted/data/gfx/PlayerCards/Card010.lin.huf":5..652
endmacro

; Player photo 11 (PlayerPhotoTable CHI 0; ASW 0)
macro Card011()
Card011:							;a player photo: 6 x 6 linear 4bpp tiles packed for DecompressHuffman, one
									;entry of the photo table
			;   in bank $9D
	db $30,$FB
	db $00,$04,$80
	incbin "../../../Extracted/data/gfx/PlayerCards/Card011.lin.huf":5..647
endmacro

; Player photo 12 (PlayerPhotoTable LA 15)
macro Card012()
Card012:							;a player photo: 6 x 6 linear 4bpp tiles packed for DecompressHuffman, one
									;entry of the photo table
			;   in bank $9D
	db $30,$FB
	db $00,$04,$80
	incbin "../../../Extracted/data/gfx/PlayerCards/Card012.lin.huf":5..643
endmacro

; Player photo 13 (PlayerPhotoTable NJ 12)
macro Card013()
Card013:							;a player photo: 6 x 6 linear 4bpp tiles packed for DecompressHuffman, one
									;entry of the photo table
			;   in bank $9D
	db $30,$FB
	db $00,$04,$80
	incbin "../../../Extracted/data/gfx/PlayerCards/Card013.lin.huf":5..641
endmacro

; Player photo 14 (PlayerPhotoTable DAL 2; ASW 4)
macro Card014()
Card014:							;a player photo: 6 x 6 linear 4bpp tiles packed for DecompressHuffman, one
									;entry of the photo table
			;   in bank $9D
	db $30,$FB
	db $00,$04,$80
	incbin "../../../Extracted/data/gfx/PlayerCards/Card014.lin.huf":5..641
endmacro

; Player photo 15 (PlayerPhotoTable WSH 2)
macro Card015()
Card015:							;a player photo: 6 x 6 linear 4bpp tiles packed for DecompressHuffman, one
									;entry of the photo table
			;   in bank $9D
	db $30,$FB
	db $00,$04,$80
	incbin "../../../Extracted/data/gfx/PlayerCards/Card015.lin.huf":5..641
endmacro

; Player photo 16 (PlayerPhotoTable NYR 5)
macro Card016()
Card016:							;a player photo: 6 x 6 linear 4bpp tiles packed for DecompressHuffman, one
									;entry of the photo table
			;   in bank $9D
	db $30,$FB
	db $00,$04,$80
	incbin "../../../Extracted/data/gfx/PlayerCards/Card016.lin.huf":5..640
endmacro

; Player photo 17 (PlayerPhotoTable CGY 0)
macro Card017()
Card017:							;a player photo: 6 x 6 linear 4bpp tiles packed for DecompressHuffman, one
									;entry of the photo table
			;   in bank $9D
	db $30,$FB
	db $00,$04,$80
	incbin "../../../Extracted/data/gfx/PlayerCards/Card017.lin.huf":5..639
endmacro

; Player photo 18 (PlayerPhotoTable EDM 7)
macro Card018()
Card018:							;a player photo: 6 x 6 linear 4bpp tiles packed for DecompressHuffman, one
									;entry of the photo table
			;   in bank $9D
	db $30,$FB
	db $00,$04,$80
	incbin "../../../Extracted/data/gfx/PlayerCards/Card018.lin.huf":5..638
endmacro

; Player photo 19 (PlayerPhotoTable VAN 17)
macro Card019()
Card019:							;a player photo: 6 x 6 linear 4bpp tiles packed for DecompressHuffman, one
									;entry of the photo table
			;   in bank $9D
	db $30,$FB
	db $00,$04,$80
	incbin "../../../Extracted/data/gfx/PlayerCards/Card019.lin.huf":5..638
endmacro

; Player photo 20 (PlayerPhotoTable FLA 0)
macro Card020()
Card020:							;a player photo: 6 x 6 linear 4bpp tiles packed for DecompressHuffman, one
									;entry of the photo table
			;   in bank $9D
	db $30,$FB
	db $00,$04,$80
	incbin "../../../Extracted/data/gfx/PlayerCards/Card020.lin.huf":5..637
endmacro

; Player photo 21 (PlayerPhotoTable NYI 15)
macro Card021()
Card021:							;a player photo: 6 x 6 linear 4bpp tiles packed for DecompressHuffman, one
									;entry of the photo table
			;   in bank $9D
	db $30,$FB
	db $00,$04,$80
	incbin "../../../Extracted/data/gfx/PlayerCards/Card021.lin.huf":5..637
endmacro

; Player photo 22 (PlayerPhotoTable EDM 13)
macro Card022()
Card022:							;a player photo: 6 x 6 linear 4bpp tiles packed for DecompressHuffman, one
									;entry of the photo table
			;   in bank $9D
	db $30,$FB
	db $00,$04,$80
	incbin "../../../Extracted/data/gfx/PlayerCards/Card022.lin.huf":5..636
endmacro

; Player photo 23 (PlayerPhotoTable LA 16)
macro Card023()
Card023:							;a player photo: 6 x 6 linear 4bpp tiles packed for DecompressHuffman, one
									;entry of the photo table
			;   in bank $9D
	db $30,$FB
	db $00,$04,$80
	incbin "../../../Extracted/data/gfx/PlayerCards/Card023.lin.huf":5..635
endmacro

; Player photo 24 (PlayerPhotoTable CHI 10)
macro Card024()
Card024:							;a player photo: 6 x 6 linear 4bpp tiles packed for DecompressHuffman, one
									;entry of the photo table
			;   in bank $9D
	db $30,$FB
	db $00,$04,$80
	incbin "../../../Extracted/data/gfx/PlayerCards/Card024.lin.huf":5..633
endmacro

; Player photo 25 (PlayerPhotoTable FLA 13)
macro Card025()
Card025:							;a player photo: 6 x 6 linear 4bpp tiles packed for DecompressHuffman, one
									;entry of the photo table
			;   in bank $9D
	db $30,$FB
	db $00,$04,$80
	incbin "../../../Extracted/data/gfx/PlayerCards/Card025.lin.huf":5..630
endmacro

; Player photo 26 (PlayerPhotoTable WPG 3)
macro Card026()
Card026:							;a player photo: 6 x 6 linear 4bpp tiles packed for DecompressHuffman, one
									;entry of the photo table
			;   in bank $9D
	db $30,$FB
	db $00,$04,$80
	incbin "../../../Extracted/data/gfx/PlayerCards/Card026.lin.huf":5..628
	db $00
endmacro

; Player photo 27 (PlayerPhotoTable MTL 6)
macro Card027()
Card027:							;a player photo: 6 x 6 linear 4bpp tiles packed for DecompressHuffman, one
									;entry of the photo table
			;   in bank $9D
	db $30,$FB
	db $00,$04,$80
	incbin "../../../Extracted/data/gfx/PlayerCards/Card027.lin.huf":5..629
endmacro

; Player photo 28 (PlayerPhotoTable LA 11)
macro Card028()
Card028:							;a player photo: 6 x 6 linear 4bpp tiles packed for DecompressHuffman, one
									;entry of the photo table
			;   in bank $9D
	db $30,$FB
	db $00,$04,$80
	incbin "../../../Extracted/data/gfx/PlayerCards/Card028.lin.huf":5..629
endmacro

; Player photo 29 (PlayerPhotoTable WSH 0)
macro Card029()
Card029:							;a player photo: 6 x 6 linear 4bpp tiles packed for DecompressHuffman, one
									;entry of the photo table
			;   in bank $9D
	db $30,$FB
	db $00,$04,$80
	incbin "../../../Extracted/data/gfx/PlayerCards/Card029.lin.huf":5..627
endmacro

; Player photo 30 (PlayerPhotoTable LA 3; ASW 8)
macro Card030()
Card030:							;a player photo: 6 x 6 linear 4bpp tiles packed for DecompressHuffman, one
									;entry of the photo table
			;   in bank $9D
	db $30,$FB
	db $00,$04,$80
	incbin "../../../Extracted/data/gfx/PlayerCards/Card030.lin.huf":5..627
endmacro

; Player photo 31 (PlayerPhotoTable LA 0)
macro Card031()
Card031:							;a player photo: 6 x 6 linear 4bpp tiles packed for DecompressHuffman, one
									;entry of the photo table
			;   in bank $9D
	db $30,$FB
	db $00,$04,$80
	incbin "../../../Extracted/data/gfx/PlayerCards/Card031.lin.huf":5..623
endmacro

; Player photo 32 (PlayerPhotoTable CGY 15)
macro Card032()
Card032:							;a player photo: 6 x 6 linear 4bpp tiles packed for DecompressHuffman, one
									;entry of the photo table
			;   in bank $9D
	db $30,$FB
	db $00,$04,$80
	incbin "../../../Extracted/data/gfx/PlayerCards/Card032.lin.huf":5..618
endmacro

; Player photo 33 (PlayerPhotoTable CGY 10; ASW 11)
macro Card033()
Card033:							;a player photo: 6 x 6 linear 4bpp tiles packed for DecompressHuffman, one
									;entry of the photo table
			;   in bank $9D
	db $30,$FB
	db $00,$04,$80
	incbin "../../../Extracted/data/gfx/PlayerCards/Card033.lin.huf":5..618
endmacro

; Player photo 34 (PlayerPhotoTable TB 0)
macro Card034()
Card034:							;a player photo: 6 x 6 linear 4bpp tiles packed for DecompressHuffman, one
									;entry of the photo table
			;   in bank $9D
	db $30,$FB
	db $00,$04,$80
	incbin "../../../Extracted/data/gfx/PlayerCards/Card034.lin.huf":5..615
endmacro

; Player photo 35 (PlayerPhotoTable DAL 9)
macro Card035()
Card035:							;a player photo: 6 x 6 linear 4bpp tiles packed for DecompressHuffman, one
									;entry of the photo table
			;   in bank $9D
	db $30,$FB
	db $00,$04,$80
	incbin "../../../Extracted/data/gfx/PlayerCards/Card035.lin.huf":5..615
endmacro

; Player photo 36 (PlayerPhotoTable BOS 0)
macro Card036()
Card036:							;a player photo: 6 x 6 linear 4bpp tiles packed for DecompressHuffman, one
									;entry of the photo table
			;   in bank $9D
	db $30,$FB
	db $00,$04,$80
	incbin "../../../Extracted/data/gfx/PlayerCards/Card036.lin.huf":5..615
endmacro

; Player photo 37 (PlayerPhotoTable SJ 16)
macro Card037()
Card037:							;a player photo: 6 x 6 linear 4bpp tiles packed for DecompressHuffman, one
									;entry of the photo table
			;   in bank $9D
	db $30,$FB
	db $00,$04,$80
	incbin "../../../Extracted/data/gfx/PlayerCards/Card037.lin.huf":5..613
endmacro

; Player photo 38 (PlayerPhotoTable FLA 11)
macro Card038()
Card038:							;a player photo: 6 x 6 linear 4bpp tiles packed for DecompressHuffman, one
									;entry of the photo table
			;   in bank $9D
	db $30,$FB
	db $00,$04,$80
	incbin "../../../Extracted/data/gfx/PlayerCards/Card038.lin.huf":5..613
endmacro

; Player photo 39 (PlayerPhotoTable TB 17)
macro Card039()
Card039:							;a player photo: 6 x 6 linear 4bpp tiles packed for DecompressHuffman, one
									;entry of the photo table
			;   in bank $9D
	db $30,$FB
	db $00,$04,$80
	incbin "../../../Extracted/data/gfx/PlayerCards/Card039.lin.huf":5..612
endmacro

; Player photo 40 (PlayerPhotoTable NJ 18)
macro Card040()
Card040:							;a player photo: 6 x 6 linear 4bpp tiles packed for DecompressHuffman, one
									;entry of the photo table
			;   in bank $9D
	db $30,$FB
	db $00,$04,$80
	incbin "../../../Extracted/data/gfx/PlayerCards/Card040.lin.huf":5..612
endmacro

; Player photo 41 (PlayerPhotoTable NYR 16)
macro Card041()
Card041:							;a player photo: 6 x 6 linear 4bpp tiles packed for DecompressHuffman, one
									;entry of the photo table
			;   in bank $9D
	db $30,$FB
	db $00,$04,$80
	incbin "../../../Extracted/data/gfx/PlayerCards/Card041.lin.huf":5..611
	db $00
endmacro

; Player photo 42 (PlayerPhotoTable SJ 15)
macro Card042()
Card042:							;a player photo: 6 x 6 linear 4bpp tiles packed for DecompressHuffman, one
									;entry of the photo table
			;   in bank $9D
	db $30,$FB
	db $00,$04,$80
	incbin "../../../Extracted/data/gfx/PlayerCards/Card042.lin.huf":5..611
endmacro

; Player photo 43 (PlayerPhotoTable EDM 15; ASW 22)
macro Card043()
Card043:							;a player photo: 6 x 6 linear 4bpp tiles packed for DecompressHuffman, one
									;entry of the photo table
			;   in bank $9D
	db $30,$FB
	db $00,$04,$80
	incbin "../../../Extracted/data/gfx/PlayerCards/Card043.lin.huf":5..609
endmacro

; Player photo 44 (PlayerPhotoTable WSH 3)
macro Card044()
Card044:							;a player photo: 6 x 6 linear 4bpp tiles packed for DecompressHuffman, one
									;entry of the photo table
			;   in bank $9D
	db $30,$FB
	db $00,$04,$80
	incbin "../../../Extracted/data/gfx/PlayerCards/Card044.lin.huf":5..608
endmacro

; Player photo 45 (PlayerPhotoTable PHI 0)
macro Card045()
Card045:							;a player photo: 6 x 6 linear 4bpp tiles packed for DecompressHuffman, one
									;entry of the photo table
			;   in bank $9D
	db $30,$FB
	db $00,$04,$80
	incbin "../../../Extracted/data/gfx/PlayerCards/Card045.lin.huf":5..608
endmacro

; Player photo 46 (PlayerPhotoTable SJ 12; ASW 15)
macro Card046()
Card046:							;a player photo: 6 x 6 linear 4bpp tiles packed for DecompressHuffman, one
									;entry of the photo table
			;   in bank $9D
	db $30,$FB
	db $00,$04,$80
	incbin "../../../Extracted/data/gfx/PlayerCards/Card046.lin.huf":5..601
	db $00
endmacro

; Player photo 47 (PlayerPhotoTable PIT 16)
macro Card047()
Card047:							;a player photo: 6 x 6 linear 4bpp tiles packed for DecompressHuffman, one
									;entry of the photo table
			;   in bank $9D
	db $30,$FB
	db $00,$04,$80
	incbin "../../../Extracted/data/gfx/PlayerCards/Card047.lin.huf":5..601
endmacro

; Player photo 48 (PlayerPhotoTable PHI 13; ASE 16)
macro Card048()
Card048:							;a player photo: 6 x 6 linear 4bpp tiles packed for DecompressHuffman, one
									;entry of the photo table
			;   in bank $9D
	db $30,$FB
	db $00,$04,$80
	incbin "../../../Extracted/data/gfx/PlayerCards/Card048.lin.huf":5..601
endmacro

; Player photo 49 (PlayerPhotoTable BUF 4)
macro Card049()
Card049:							;a player photo: 6 x 6 linear 4bpp tiles packed for DecompressHuffman, one
									;entry of the photo table
			;   in bank $9D
	db $30,$FB
	db $00,$04,$80
	incbin "../../../Extracted/data/gfx/PlayerCards/Card049.lin.huf":5..601
endmacro

; Player photo 50 (PlayerPhotoTable FLA 4)
macro Card050()
Card050:							;a player photo: 6 x 6 linear 4bpp tiles packed for DecompressHuffman, one
									;entry of the photo table
			;   in bank $9D
	db $30,$FB
	db $00,$04,$80
	incbin "../../../Extracted/data/gfx/PlayerCards/Card050.lin.huf":5..599
endmacro

; Player photo 51 (PlayerPhotoTable DAL 16)
macro Card051()
Card051:							;a player photo: 6 x 6 linear 4bpp tiles packed for DecompressHuffman, one
									;entry of the photo table
			;   in bank $9D
	db $30,$FB
	db $00,$04,$80
	incbin "../../../Extracted/data/gfx/PlayerCards/Card051.lin.huf":5..599
endmacro

; Player photo 52 (PlayerPhotoTable NYI 7)
macro Card052()
Card052:							;a player photo: 6 x 6 linear 4bpp tiles packed for DecompressHuffman, one
									;entry of the photo table
			;   in bank $9D
	db $30,$FB
	db $00,$04,$80
	incbin "../../../Extracted/data/gfx/PlayerCards/Card052.lin.huf":5..598
endmacro

; Player photo 53 (PlayerPhotoTable BUF 16)
macro Card053()
Card053:							;a player photo: 6 x 6 linear 4bpp tiles packed for DecompressHuffman, one
									;entry of the photo table
			;   in bank $9D
	db $30,$FB
	db $00,$04,$80
	incbin "../../../Extracted/data/gfx/PlayerCards/Card053.lin.huf":5..596
endmacro

; Player photo 54 (PlayerPhotoTable CHI 6)
macro Card054()
Card054:							;a player photo: 6 x 6 linear 4bpp tiles packed for DecompressHuffman, one
									;entry of the photo table
			;   in bank $9D
	db $30,$FB
	db $00,$04,$80
	incbin "../../../Extracted/data/gfx/PlayerCards/Card054.lin.huf":5..594
	db $00
endmacro

; Player photo 55 (PlayerPhotoTable SJ 0)
macro Card055()
Card055:							;a player photo: 6 x 6 linear 4bpp tiles packed for DecompressHuffman, one
									;entry of the photo table
			;   in bank $9D
	db $30,$FB
	db $00,$04,$80
	incbin "../../../Extracted/data/gfx/PlayerCards/Card055.lin.huf":5..595
endmacro

; Player photo 56 (PlayerPhotoTable HFD 7)
macro Card056()
Card056:							;a player photo: 6 x 6 linear 4bpp tiles packed for DecompressHuffman, one
									;entry of the photo table
			;   in bank $9D
	db $30,$FB
	db $00,$04,$80
	incbin "../../../Extracted/data/gfx/PlayerCards/Card056.lin.huf":5..594
endmacro

; Player photo 57 (PlayerPhotoTable HFD 18)
macro Card057()
Card057:							;a player photo: 6 x 6 linear 4bpp tiles packed for DecompressHuffman, one
									;entry of the photo table
			;   in bank $9D
	db $30,$FB
	db $00,$04,$80
	incbin "../../../Extracted/data/gfx/PlayerCards/Card057.lin.huf":5..593
endmacro

; Player photo 58 (PlayerPhotoTable BUF 17)
macro Card058()
Card058:							;a player photo: 6 x 6 linear 4bpp tiles packed for DecompressHuffman, one
									;entry of the photo table
			;   in bank $9D
	db $30,$FB
	db $00,$04,$80
	incbin "../../../Extracted/data/gfx/PlayerCards/Card058.lin.huf":5..591
endmacro

; Player photo 59 (PlayerPhotoTable SJ 3)
macro Card059()
Card059:							;a player photo: 6 x 6 linear 4bpp tiles packed for DecompressHuffman, one
									;entry of the photo table
			;   in bank $9D
	db $30,$FB
	db $00,$04,$80
	incbin "../../../Extracted/data/gfx/PlayerCards/Card059.lin.huf":5..591
endmacro

; Player photo 60 (PlayerPhotoTable HFD 12)
macro Card060()
Card060:							;a player photo: 6 x 6 linear 4bpp tiles packed for DecompressHuffman, one
									;entry of the photo table
			;   in bank $9D
	db $30,$FB
	db $00,$04,$80
	incbin "../../../Extracted/data/gfx/PlayerCards/Card060.lin.huf":5..591
endmacro

; Player photo 61 (PlayerPhotoTable VAN 11; ASW 13)
macro Card061()
Card061:							;a player photo: 6 x 6 linear 4bpp tiles packed for DecompressHuffman, one
									;entry of the photo table
			;   in bank $9D
	db $30,$FB
	db $00,$04,$80
	incbin "../../../Extracted/data/gfx/PlayerCards/Card061.lin.huf":5..590
endmacro

; Player photo 62 (PlayerPhotoTable VAN 5)
macro Card062()
Card062:							;a player photo: 6 x 6 linear 4bpp tiles packed for DecompressHuffman, one
									;entry of the photo table
			;   in bank $9D
	db $30,$FB
	db $00,$04,$80
	incbin "../../../Extracted/data/gfx/PlayerCards/Card062.lin.huf":5..590
endmacro

; Player photo 63 (PlayerPhotoTable ANH 5)
macro Card063()
Card063:							;a player photo: 6 x 6 linear 4bpp tiles packed for DecompressHuffman, one
									;entry of the photo table
			;   in bank $9D
	db $30,$FB
	db $00,$04,$80
	incbin "../../../Extracted/data/gfx/PlayerCards/Card063.lin.huf":5..590
endmacro

; Player photo 64 (PlayerPhotoTable NYR 1; ASE 4)
macro Card064()
Card064:							;a player photo: 6 x 6 linear 4bpp tiles packed for DecompressHuffman, one
									;entry of the photo table
			;   in bank $9D
	db $30,$FB
	db $00,$04,$80
	incbin "../../../Extracted/data/gfx/PlayerCards/Card064.lin.huf":5..589
endmacro

; Player photo 65 (PlayerPhotoTable PHI 16)
macro Card065()
Card065:							;a player photo: 6 x 6 linear 4bpp tiles packed for DecompressHuffman, one
									;entry of the photo table
			;   in bank $9D
	db $30,$FB
	db $00,$04,$80
	incbin "../../../Extracted/data/gfx/PlayerCards/Card065.lin.huf":5..589
endmacro

; Player photo 66 (PlayerPhotoTable VAN 0)
macro Card066()
Card066:							;a player photo: 6 x 6 linear 4bpp tiles packed for DecompressHuffman, one
									;entry of the photo table
			;   in bank $9D
	db $30,$FB
	db $00,$04,$80
	incbin "../../../Extracted/data/gfx/PlayerCards/Card066.lin.huf":5..589
endmacro

; Player photo 67 (PlayerPhotoTable WSH 17; ASE 21)
macro Card067()
Card067:							;a player photo: 6 x 6 linear 4bpp tiles packed for DecompressHuffman, one
									;entry of the photo table
			;   in bank $9D
	db $30,$FB
	db $00,$04,$80
	incbin "../../../Extracted/data/gfx/PlayerCards/Card067.lin.huf":5..588
endmacro

; Player photo 68 (PlayerPhotoTable MTL 11)
macro Card068()
Card068:							;a player photo: 6 x 6 linear 4bpp tiles packed for DecompressHuffman, one
									;entry of the photo table
			;   in bank $9D
	db $30,$FB
	db $00,$04,$80
	incbin "../../../Extracted/data/gfx/PlayerCards/Card068.lin.huf":5..585
	db $00
endmacro

; Player photo 69 (PlayerPhotoTable ANH 11)
macro Card069()
Card069:							;a player photo: 6 x 6 linear 4bpp tiles packed for DecompressHuffman, one
									;entry of the photo table
			;   in bank $9D
	db $30,$FB
	db $00,$04,$80
	incbin "../../../Extracted/data/gfx/PlayerCards/Card069.lin.huf":5..586
endmacro

; Player photo 70 (PlayerPhotoTable NYR 9; ASE 13)
macro Card070()
Card070:							;a player photo: 6 x 6 linear 4bpp tiles packed for DecompressHuffman, one
									;entry of the photo table
			;   in bank $9D
	db $30,$FB
	db $00,$04,$80
	incbin "../../../Extracted/data/gfx/PlayerCards/Card070.lin.huf":5..585
endmacro

; Player photo 71 (PlayerPhotoTable ANH 7)
macro Card071()
Card071:							;a player photo: 6 x 6 linear 4bpp tiles packed for DecompressHuffman, one
									;entry of the photo table
			;   in bank $9D
	db $30,$FB
	db $00,$04,$80
	incbin "../../../Extracted/data/gfx/PlayerCards/Card071.lin.huf":5..585
endmacro

; Player photo 72 (PlayerPhotoTable TOR 16)
macro Card072()
Card072:							;a player photo: 6 x 6 linear 4bpp tiles packed for DecompressHuffman, one
									;entry of the photo table
			;   in bank $9D
	db $30,$FB
	db $00,$04,$80
	incbin "../../../Extracted/data/gfx/PlayerCards/Card072.lin.huf":5..584
endmacro

; Player photo 73 (PlayerPhotoTable LA 7; ASW 10)
macro Card073()
Card073:							;a player photo: 6 x 6 linear 4bpp tiles packed for DecompressHuffman, one
									;entry of the photo table
			;   in bank $9D
	db $30,$FB
	db $00,$04,$80
	incbin "../../../Extracted/data/gfx/PlayerCards/Card073.lin.huf":5..584
endmacro

; Player photo 74 (PlayerPhotoTable EDM 1)
macro Card074()
Card074:							;a player photo: 6 x 6 linear 4bpp tiles packed for DecompressHuffman, one
									;entry of the photo table
			;   in bank $9D
	db $30,$FB
	db $00,$04,$80
	incbin "../../../Extracted/data/gfx/PlayerCards/Card074.lin.huf":5..582
endmacro

; Player photo 75 (PlayerPhotoTable PHI 3)
macro Card075()
Card075:							;a player photo: 6 x 6 linear 4bpp tiles packed for DecompressHuffman, one
									;entry of the photo table
			;   in bank $9D
	db $30,$FB
	db $00,$04,$80
	incbin "../../../Extracted/data/gfx/PlayerCards/Card075.lin.huf":5..581
endmacro

; Player photo 76 (PlayerPhotoTable HFD 0)
macro Card076()
Card076:							;a player photo: 6 x 6 linear 4bpp tiles packed for DecompressHuffman, one
									;entry of the photo table
			;   in bank $9D
	db $30,$FB
	db $00,$04,$80
	incbin "../../../Extracted/data/gfx/PlayerCards/Card076.lin.huf":5..581
endmacro

; Player photo 77 (PlayerPhotoTable STL 14; ASW 18)
macro Card077()
Card077:							;a player photo: 6 x 6 linear 4bpp tiles packed for DecompressHuffman, one
									;entry of the photo table
			;   in bank $9D
	db $30,$FB
	db $00,$04,$80
	incbin "../../../Extracted/data/gfx/PlayerCards/Card077.lin.huf":5..579
endmacro

; Player photo 78 (PlayerPhotoTable BOS 6)
macro Card078()
Card078:							;a player photo: 6 x 6 linear 4bpp tiles packed for DecompressHuffman, one
									;entry of the photo table
			;   in bank $9D
	db $30,$FB
	db $00,$04,$80
	incbin "../../../Extracted/data/gfx/PlayerCards/Card078.lin.huf":5..579
endmacro

; Player photo 79 (PlayerPhotoTable PIT 6; ASE 10)
macro Card079()
Card079:							;a player photo: 6 x 6 linear 4bpp tiles packed for DecompressHuffman, one
									;entry of the photo table
			;   in bank $9D
	db $30,$FB
	db $00,$04,$80
	incbin "../../../Extracted/data/gfx/PlayerCards/Card079.lin.huf":5..579
endmacro

; Player photo 80 (PlayerPhotoTable WSH 16)
macro Card080()
Card080:							;a player photo: 6 x 6 linear 4bpp tiles packed for DecompressHuffman, one
									;entry of the photo table
			;   in bank $9D
	db $30,$FB
	db $00,$04,$80
	incbin "../../../Extracted/data/gfx/PlayerCards/Card080.lin.huf":5..578
endmacro

; Player photo 81 (PlayerPhotoTable CHI 2; ASW 5)
macro Card081()
Card081:							;a player photo: 6 x 6 linear 4bpp tiles packed for DecompressHuffman, one
									;entry of the photo table
			;   in bank $9D
	db $30,$FB
	db $00,$04,$80
	incbin "../../../Extracted/data/gfx/PlayerCards/Card081.lin.huf":5..577
endmacro

; Player photo 82 (PlayerPhotoTable DAL 15)
macro Card082()
Card082:							;a player photo: 6 x 6 linear 4bpp tiles packed for DecompressHuffman, one
									;entry of the photo table
			;   in bank $9D
	db $30,$FB
	db $00,$04,$80
	incbin "../../../Extracted/data/gfx/PlayerCards/Card082.lin.huf":5..577
endmacro

; Player photo 83 (PlayerPhotoTable QUE 0)
macro Card083()
Card083:							;a player photo: 6 x 6 linear 4bpp tiles packed for DecompressHuffman, one
									;entry of the photo table
			;   in bank $9D
	db $30,$FB
	db $00,$04,$80
	incbin "../../../Extracted/data/gfx/PlayerCards/Card083.lin.huf":5..577
endmacro

; Player photo 84 (PlayerPhotoTable NJ 17; ASE 22)
macro Card084()
Card084:							;a player photo: 6 x 6 linear 4bpp tiles packed for DecompressHuffman, one
									;entry of the photo table
			;   in bank $9D
	db $30,$FB
	db $00,$04,$80
	incbin "../../../Extracted/data/gfx/PlayerCards/Card084.lin.huf":5..577
endmacro

; Player photo 85 (PlayerPhotoTable STL 10; ASW 12)
macro Card085()
Card085:							;a player photo: 6 x 6 linear 4bpp tiles packed for DecompressHuffman, one
									;entry of the photo table
			;   in bank $9D
	db $30,$FB
	db $00,$04,$80
	incbin "../../../Extracted/data/gfx/PlayerCards/Card085.lin.huf":5..574
endmacro

; Player photo 86 (PlayerPhotoTable DET 0; ASW 1)
macro Card086()
Card086:							;a player photo: 6 x 6 linear 4bpp tiles packed for DecompressHuffman, one
									;entry of the photo table
			;   in bank $9D
	db $30,$FB
	db $00,$04,$80
	incbin "../../../Extracted/data/gfx/PlayerCards/Card086.lin.huf":5..572
	db $00
endmacro

; Player photo 87 (PlayerPhotoTable BOS 2; ASE 6)
macro Card087()
Card087:							;a player photo: 6 x 6 linear 4bpp tiles packed for DecompressHuffman, one
									;entry of the photo table
			;   in bank $9D
	db $30,$FB
	db $00,$04,$80
	incbin "../../../Extracted/data/gfx/PlayerCards/Card087.lin.huf":5..573
endmacro

; Player photo 88 (PlayerPhotoTable SJ 8)
macro Card088()
Card088:							;a player photo: 6 x 6 linear 4bpp tiles packed for DecompressHuffman, one
									;entry of the photo table
			;   in bank $9D
	db $30,$FB
	db $00,$04,$80
	incbin "../../../Extracted/data/gfx/PlayerCards/Card088.lin.huf":5..573
endmacro

; Player photo 89 (PlayerPhotoTable PHI 4)
macro Card089()
Card089:							;a player photo: 6 x 6 linear 4bpp tiles packed for DecompressHuffman, one
									;entry of the photo table
			;   in bank $9D
	db $30,$FB
	db $00,$04,$80
	incbin "../../../Extracted/data/gfx/PlayerCards/Card089.lin.huf":5..573
endmacro

; Player photo 90 (PlayerPhotoTable BOS 17; ASE 18)
macro Card090()
Card090:							;a player photo: 6 x 6 linear 4bpp tiles packed for DecompressHuffman, one
									;entry of the photo table
			;   in bank $9D
	db $30,$FB
	db $00,$04,$80
	incbin "../../../Extracted/data/gfx/PlayerCards/Card090.lin.huf":5..573
endmacro

; Player photo 91 (PlayerPhotoTable WPG 18)
macro Card091()
Card091:							;a player photo: 6 x 6 linear 4bpp tiles packed for DecompressHuffman, one
									;entry of the photo table
			;   in bank $9D
	db $30,$FB
	db $00,$04,$80
	incbin "../../../Extracted/data/gfx/PlayerCards/Card091.lin.huf":5..572
endmacro

; Player photo 92 (PlayerPhotoTable FLA 3)
macro Card092()
Card092:							;a player photo: 6 x 6 linear 4bpp tiles packed for DecompressHuffman, one
									;entry of the photo table
			;   in bank $9D
	db $30,$FB
	db $00,$04,$80
	incbin "../../../Extracted/data/gfx/PlayerCards/Card092.lin.huf":5..569
	db $00
endmacro

; Player photo 93 (PlayerPhotoTable NYI 0)
macro Card093()
Card093:							;a player photo: 6 x 6 linear 4bpp tiles packed for DecompressHuffman, one
									;entry of the photo table
			;   in bank $9D
	db $30,$FB
	db $00,$04,$80
	incbin "../../../Extracted/data/gfx/PlayerCards/Card093.lin.huf":5..569
endmacro

; Player photo 94 (PlayerPhotoTable MTL 16)
macro Card094()
Card094:							;a player photo: 6 x 6 linear 4bpp tiles packed for DecompressHuffman, one
									;entry of the photo table
			;   in bank $9D
	db $30,$FB
	db $00,$04,$80
	incbin "../../../Extracted/data/gfx/PlayerCards/Card094.lin.huf":5..568
	db $00
endmacro

; Player photo 95 (PlayerPhotoTable CHI 17; ASW 23)
macro Card095()
Card095:							;a player photo: 6 x 6 linear 4bpp tiles packed for DecompressHuffman, one
									;entry of the photo table
			;   in bank $9D
	db $30,$FB
	db $00,$04,$80
	incbin "../../../Extracted/data/gfx/PlayerCards/Card095.lin.huf":5..568
endmacro

; Player photo 96 (PlayerPhotoTable BUF 0; ASE 1)
macro Card096()
Card096:							;a player photo: 6 x 6 linear 4bpp tiles packed for DecompressHuffman, one
									;entry of the photo table
			;   in bank $9D
	db $30,$FB
	db $00,$04,$80
	incbin "../../../Extracted/data/gfx/PlayerCards/Card096.lin.huf":5..566
endmacro

; Player photo 97 (PlayerPhotoTable TOR 0; ASW 2)
macro Card097()
Card097:							;a player photo: 6 x 6 linear 4bpp tiles packed for DecompressHuffman, one
									;entry of the photo table
			;   in bank $9D
	db $30,$FB
	db $00,$04,$80
	incbin "../../../Extracted/data/gfx/PlayerCards/Card097.lin.huf":5..564
	db $00
endmacro

; Player photo 98 (PlayerPhotoTable NYI 2)
macro Card098()
Card098:							;a player photo: 6 x 6 linear 4bpp tiles packed for DecompressHuffman, one
									;entry of the photo table
			;   in bank $9D
	db $30,$FB
	db $00,$04,$80
	incbin "../../../Extracted/data/gfx/PlayerCards/Card098.lin.huf":5..565
endmacro

; Player photo 99 (PlayerPhotoTable EDM 0)
macro Card099()
Card099:							;a player photo: 6 x 6 linear 4bpp tiles packed for DecompressHuffman, one
									;entry of the photo table
			;   in bank $9D
	db $30,$FB
	db $00,$04,$80
	incbin "../../../Extracted/data/gfx/PlayerCards/Card099.lin.huf":5..564
	db $00
endmacro

; Player photo 100 (PlayerPhotoTable WPG 0)
macro Card100()
Card100:							;a player photo: 6 x 6 linear 4bpp tiles packed for DecompressHuffman, one
									;entry of the photo table
			;   in bank $9D
	db $30,$FB
	db $00,$04,$80
	incbin "../../../Extracted/data/gfx/PlayerCards/Card100.lin.huf":5..565
endmacro

; Player photo 101 (PlayerPhotoTable BOS 11)
macro Card101()
Card101:							;a player photo: 6 x 6 linear 4bpp tiles packed for DecompressHuffman, one
									;entry of the photo table
			;   in bank $9D
	db $30,$FB
	db $00,$04,$80
	incbin "../../../Extracted/data/gfx/PlayerCards/Card101.lin.huf":5..565
endmacro

; Player photo 102 (PlayerPhotoTable HFD 17; ASE 23)
macro Card102()
Card102:							;a player photo: 6 x 6 linear 4bpp tiles packed for DecompressHuffman, one
									;entry of the photo table
			;   in bank $9D
	db $30,$FB
	db $00,$04,$80
	incbin "../../../Extracted/data/gfx/PlayerCards/Card102.lin.huf":5..564
endmacro

; Player photo 103 (PlayerPhotoTable TB 4)
macro Card103()
Card103:							;a player photo: 6 x 6 linear 4bpp tiles packed for DecompressHuffman, one
									;entry of the photo table
			;   in bank $9D
	db $30,$FB
	db $00,$04,$80
	incbin "../../../Extracted/data/gfx/PlayerCards/Card103.lin.huf":5..564
endmacro

; Player photo 104 (PlayerPhotoTable STL 9)
macro Card104()
Card104:							;a player photo: 6 x 6 linear 4bpp tiles packed for DecompressHuffman, one
									;entry of the photo table
			;   in bank $9D
	db $30,$FB
	db $00,$04,$80
	incbin "../../../Extracted/data/gfx/PlayerCards/Card104.lin.huf":5..564
endmacro

; Player photo 105 (PlayerPhotoTable QUE 2; ASE 7)
macro Card105()
Card105:							;a player photo: 6 x 6 linear 4bpp tiles packed for DecompressHuffman, one
									;entry of the photo table
			;   in bank $9D
	db $30,$FB
	db $00,$04,$80
	incbin "../../../Extracted/data/gfx/PlayerCards/Card105.lin.huf":5..563
endmacro

; Player photo 106 (PlayerPhotoTable WPG 2)
macro Card106()
Card106:							;a player photo: 6 x 6 linear 4bpp tiles packed for DecompressHuffman, one
									;entry of the photo table
			;   in bank $9D
	db $30,$FB
	db $00,$04,$80
	incbin "../../../Extracted/data/gfx/PlayerCards/Card106.lin.huf":5..562
endmacro

; Player photo 107 (PlayerPhotoTable CGY 5; ASW 9)
macro Card107()
Card107:							;a player photo: 6 x 6 linear 4bpp tiles packed for DecompressHuffman, one
									;entry of the photo table
			;   in bank $9D
	db $30,$FB
	db $00,$04,$80
	incbin "../../../Extracted/data/gfx/PlayerCards/Card107.lin.huf":5..561
endmacro

; Player photo 108 (PlayerPhotoTable ANH 0)
macro Card108()
Card108:							;a player photo: 6 x 6 linear 4bpp tiles packed for DecompressHuffman, one
									;entry of the photo table
			;   in bank $9D
	db $30,$FB
	db $00,$04,$80
	incbin "../../../Extracted/data/gfx/PlayerCards/Card108.lin.huf":5..561
endmacro

; Player photo 109 (PlayerPhotoTable OTT 9)
macro Card109()
Card109:							;a player photo: 6 x 6 linear 4bpp tiles packed for DecompressHuffman, one
									;entry of the photo table
			;   in bank $9D
	db $30,$FB
	db $00,$04,$80
	incbin "../../../Extracted/data/gfx/PlayerCards/Card109.lin.huf":5..560
endmacro

; Player photo 110 (PlayerPhotoTable EDM 16)
macro Card110()
Card110:							;a player photo: 6 x 6 linear 4bpp tiles packed for DecompressHuffman, one
									;entry of the photo table
			;   in bank $9D
	db $30,$FB
	db $00,$04,$80
	incbin "../../../Extracted/data/gfx/PlayerCards/Card110.lin.huf":5..560
endmacro

; Player photo 111 (PlayerPhotoTable BUF 3; ASE 9)
macro Card111()
Card111:							;a player photo: 6 x 6 linear 4bpp tiles packed for DecompressHuffman, one
									;entry of the photo table
			;   in bank $9D
	db $30,$FB
	db $00,$04,$80
	incbin "../../../Extracted/data/gfx/PlayerCards/Card111.lin.huf":5..560
endmacro

; Player photo 112 (PlayerPhotoTable CHI 16; ASW 20)
macro Card112()
Card112:							;a player photo: 6 x 6 linear 4bpp tiles packed for DecompressHuffman, one
									;entry of the photo table
			;   in bank $9D
	db $30,$FB
	db $00,$04,$80
	incbin "../../../Extracted/data/gfx/PlayerCards/Card112.lin.huf":5..559
endmacro

; Player photo 113 (PlayerPhotoTable VAN 2)
macro Card113()
Card113:							;a player photo: 6 x 6 linear 4bpp tiles packed for DecompressHuffman, one
									;entry of the photo table
			;   in bank $9D
	db $30,$FB
	db $00,$04,$80
	incbin "../../../Extracted/data/gfx/PlayerCards/Card113.lin.huf":5..556
endmacro

; Player photo 114 (PlayerPhotoTable TB 3; ASW 6)
macro Card114()
Card114:							;a player photo: 6 x 6 linear 4bpp tiles packed for DecompressHuffman, one
									;entry of the photo table
			;   in bank $9D
	db $30,$FB
	db $00,$04,$80
	incbin "../../../Extracted/data/gfx/PlayerCards/Card114.lin.huf":5..553
endmacro

; Player photo 115 (PlayerPhotoTable ANH 13)
macro Card115()
Card115:							;a player photo: 6 x 6 linear 4bpp tiles packed for DecompressHuffman, one
									;entry of the photo table
			;   in bank $9D
	db $30,$FB
	db $00,$04,$80
	incbin "../../../Extracted/data/gfx/PlayerCards/Card115.lin.huf":5..553
endmacro

; Player photo 116 (PlayerPhotoTable BUF 12; ASE 15)
macro Card116()
Card116:							;a player photo: 6 x 6 linear 4bpp tiles packed for DecompressHuffman, one
									;entry of the photo table
			;   in bank $9D
	db $30,$FB
	db $00,$04,$80
	incbin "../../../Extracted/data/gfx/PlayerCards/Card116.lin.huf":5..552
endmacro

; Player photo 117 (PlayerPhotoTable DET 2; ASW 3)
macro Card117()
Card117:							;a player photo: 6 x 6 linear 4bpp tiles packed for DecompressHuffman, one
									;entry of the photo table
			;   in bank $9D
	db $30,$FB
	db $00,$04,$80
	incbin "../../../Extracted/data/gfx/PlayerCards/Card117.lin.huf":5..552
endmacro

; Player photo 118 (PlayerPhotoTable CGY 2)
macro Card118()
Card118:							;a player photo: 6 x 6 linear 4bpp tiles packed for DecompressHuffman, one
									;entry of the photo table
			;   in bank $9D
	db $30,$FB
	db $00,$04,$80
	incbin "../../../Extracted/data/gfx/PlayerCards/Card118.lin.huf":5..548
endmacro

; Player photo 119 (PlayerPhotoTable BOS 18)
macro Card119()
Card119:							;a player photo: 6 x 6 linear 4bpp tiles packed for DecompressHuffman, one
									;entry of the photo table
			;   in bank $9D
	db $30,$FB
	db $00,$04,$80
	incbin "../../../Extracted/data/gfx/PlayerCards/Card119.lin.huf":5..547
endmacro

; Player photo 120 (PlayerPhotoTable QUE 15; ASE 20)
macro Card120()
Card120:							;a player photo: 6 x 6 linear 4bpp tiles packed for DecompressHuffman, one
									;entry of the photo table
			;   in bank $9D
	db $30,$FB
	db $00,$04,$80
	incbin "../../../Extracted/data/gfx/PlayerCards/Card120.lin.huf":5..543
	db $00
endmacro

; Player photo 121 (PlayerPhotoTable NJ 2)
macro Card121()
Card121:							;a player photo: 6 x 6 linear 4bpp tiles packed for DecompressHuffman, one
									;entry of the photo table
			;   in bank $9D
	db $30,$FB
	db $00,$04,$80
	incbin "../../../Extracted/data/gfx/PlayerCards/Card121.lin.huf":5..544
endmacro

; Player photo 122 (PlayerPhotoTable TOR 17)
macro Card122()
Card122:							;a player photo: 6 x 6 linear 4bpp tiles packed for DecompressHuffman, one
									;entry of the photo table
			;   in bank $9D
	db $30,$FB
	db $00,$04,$80
	incbin "../../../Extracted/data/gfx/PlayerCards/Card122.lin.huf":5..538
endmacro

; Player photo 123 (PlayerPhotoTable OTT 19)
macro Card123()
Card123:							;a player photo: 6 x 6 linear 4bpp tiles packed for DecompressHuffman, one
									;entry of the photo table
			;   in bank $9D
	db $30,$FB
	db $00,$04,$80
	incbin "../../../Extracted/data/gfx/PlayerCards/Card123.lin.huf":5..537
	db $00
endmacro

; Player photo 124 (PlayerPhotoTable VAN 16)
macro Card124()
Card124:							;a player photo: 6 x 6 linear 4bpp tiles packed for DecompressHuffman, one
									;entry of the photo table
			;   in bank $9D
	db $30,$FB
	db $00,$04,$80
	incbin "../../../Extracted/data/gfx/PlayerCards/Card124.lin.huf":5..538
endmacro

; Player photo 125 (PlayerPhotoTable MTL 17)
macro Card125()
Card125:							;a player photo: 6 x 6 linear 4bpp tiles packed for DecompressHuffman, one
									;entry of the photo table
			;   in bank $9D
	db $30,$FB
	db $00,$04,$80
	incbin "../../../Extracted/data/gfx/PlayerCards/Card125.lin.huf":5..537
endmacro

; Player photo 126 (PlayerPhotoTable STL 15)
macro Card126()
Card126:							;a player photo: 6 x 6 linear 4bpp tiles packed for DecompressHuffman, one
									;entry of the photo table
			;   in bank $9D
	db $30,$FB
	db $00,$04,$80
	incbin "../../../Extracted/data/gfx/PlayerCards/Card126.lin.huf":5..536
endmacro

; Player photo 127 (PlayerPhotoTable OTT 2)
macro Card127()
Card127:							;a player photo: 6 x 6 linear 4bpp tiles packed for DecompressHuffman, one
									;entry of the photo table
			;   in bank $9D
	db $30,$FB
	db $00,$04,$80
	incbin "../../../Extracted/data/gfx/PlayerCards/Card127.lin.huf":5..536
endmacro

; Player photo 128 (PlayerPhotoTable PHI 17)
macro Card128()
Card128:							;a player photo: 6 x 6 linear 4bpp tiles packed for DecompressHuffman, one
									;entry of the photo table
			;   in bank $9D
	db $30,$FB
	db $00,$04,$80
	incbin "../../../Extracted/data/gfx/PlayerCards/Card128.lin.huf":5..531
endmacro

; Player photo 129 (PlayerPhotoTable OTT 18)
macro Card129()
Card129:							;a player photo: 6 x 6 linear 4bpp tiles packed for DecompressHuffman, one
									;entry of the photo table
			;   in bank $9D
	db $30,$FB
	db $00,$04,$80
	incbin "../../../Extracted/data/gfx/PlayerCards/Card129.lin.huf":5..529
	db $00
endmacro

; Player photo 130 (PlayerPhotoTable WSH 11; ASE 12)
macro Card130()
Card130:							;a player photo: 6 x 6 linear 4bpp tiles packed for DecompressHuffman, one
									;entry of the photo table
			;   in bank $9D
	db $30,$FB
	db $00,$04,$80
	incbin "../../../Extracted/data/gfx/PlayerCards/Card130.lin.huf":5..530
endmacro

; Player photo 131 (PlayerPhotoTable HFD 3)
macro Card131()
Card131:							;a player photo: 6 x 6 linear 4bpp tiles packed for DecompressHuffman, one
									;entry of the photo table
			;   in bank $9D
	db $30,$FB
	db $00,$04,$80
	incbin "../../../Extracted/data/gfx/PlayerCards/Card131.lin.huf":5..529
endmacro

; Player photo 132 (PlayerPhotoTable NYI 14)
macro Card132()
Card132:							;a player photo: 6 x 6 linear 4bpp tiles packed for DecompressHuffman, one
									;entry of the photo table
			;   in bank $9D
	db $30,$FB
	db $00,$04,$80
	incbin "../../../Extracted/data/gfx/PlayerCards/Card132.lin.huf":5..528
endmacro

; Player photo 133 (PlayerPhotoTable TB 10)
macro Card133()
Card133:							;a player photo: 6 x 6 linear 4bpp tiles packed for DecompressHuffman, one
									;entry of the photo table
			;   in bank $9D
	db $30,$FB
	db $00,$04,$80
	incbin "../../../Extracted/data/gfx/PlayerCards/Card133.lin.huf":5..527
endmacro

; Player photo 134 (PlayerPhotoTable OTT 14)
macro Card134()
Card134:							;a player photo: 6 x 6 linear 4bpp tiles packed for DecompressHuffman, one
									;entry of the photo table
			;   in bank $9D
	db $30,$FB
	db $00,$04,$80
	incbin "../../../Extracted/data/gfx/PlayerCards/Card134.lin.huf":5..523
endmacro

; Player photo 135 (PlayerPhotoTable PIT 0; ASE 2)
macro Card135()
Card135:							;a player photo: 6 x 6 linear 4bpp tiles packed for DecompressHuffman, one
									;entry of the photo table
			;   in bank $9D
	db $30,$FB
	db $00,$04,$80
	incbin "../../../Extracted/data/gfx/PlayerCards/Card135.lin.huf":5..521
endmacro

; Player photo 136 (PlayerPhotoTable MTL 2; ASE 5)
macro Card136()
Card136:							;a player photo: 6 x 6 linear 4bpp tiles packed for DecompressHuffman, one
									;entry of the photo table
			;   in bank $9D
	db $30,$FB
	db $00,$04,$80
	incbin "../../../Extracted/data/gfx/PlayerCards/Card136.lin.huf":5..520
endmacro

; Player photo 137 (PlayerPhotoTable DET 18; ASW 24)
macro Card137()
Card137:							;a player photo: 6 x 6 linear 4bpp tiles packed for DecompressHuffman, one
									;entry of the photo table
			;   in bank $9D
	db $30,$FB
	db $00,$04,$80
	incbin "../../../Extracted/data/gfx/PlayerCards/Card137.lin.huf":5..518
endmacro

; Player photo 138 (PlayerPhotoTable TOR 7)
macro Card138()
Card138:							;a player photo: 6 x 6 linear 4bpp tiles packed for DecompressHuffman, one
									;entry of the photo table
			;   in bank $9D
	db $30,$FB
	db $00,$04,$80
	incbin "../../../Extracted/data/gfx/PlayerCards/Card138.lin.huf":5..518
endmacro

; Player photo 139 (PlayerPhotoTable QUE 12)
macro Card139()
Card139:							;a player photo: 6 x 6 linear 4bpp tiles packed for DecompressHuffman, one
									;entry of the photo table
			;   in bank $9D
	db $30,$FB
	db $00,$04,$80
	incbin "../../../Extracted/data/gfx/PlayerCards/Card139.lin.huf":5..517
	db $00
endmacro

; Player photo 140 (PlayerPhotoTable NYI 1; ASE 8)
macro Card140()
Card140:							;a player photo: 6 x 6 linear 4bpp tiles packed for DecompressHuffman, one
									;entry of the photo table
			;   in bank $9D
	db $30,$FB
	db $00,$04,$80
	incbin "../../../Extracted/data/gfx/PlayerCards/Card140.lin.huf":5..517
endmacro

; Player photo 141 (PlayerPhotoTable WPG 12; ASW 14)
macro Card141()
Card141:							;a player photo: 6 x 6 linear 4bpp tiles packed for DecompressHuffman, one
									;entry of the photo table
			;   in bank $9D
	db $30,$FB
	db $00,$04,$80
	incbin "../../../Extracted/data/gfx/PlayerCards/Card141.lin.huf":5..516
endmacro

; Player photo 142 (PlayerPhotoTable MTL 0; ASE 0)
macro Card142()
Card142:							;a player photo: 6 x 6 linear 4bpp tiles packed for DecompressHuffman, one
									;entry of the photo table
			;   in bank $9D
	db $30,$FB
	db $00,$04,$80
	incbin "../../../Extracted/data/gfx/PlayerCards/Card142.lin.huf":5..516
endmacro

; Player photo 143 (PlayerPhotoTable TB 18)
macro Card143()
Card143:							;a player photo: 6 x 6 linear 4bpp tiles packed for DecompressHuffman, one
									;entry of the photo table
			;   in bank $9D
	db $30,$FB
	db $00,$04,$80
	incbin "../../../Extracted/data/gfx/PlayerCards/Card143.lin.huf":5..510
	db $00
endmacro

; Player photo 144 (PlayerPhotoTable PIT 15; ASE 17)
macro Card144()
Card144:							;a player photo: 6 x 6 linear 4bpp tiles packed for DecompressHuffman, one
									;entry of the photo table
			;   in bank $9D
	db $30,$FB
	db $00,$04,$80
	incbin "../../../Extracted/data/gfx/PlayerCards/Card144.lin.huf":5..507
endmacro

; Player photo 145 (PlayerPhotoTable DAL 3)
macro Card145()
Card145:							;a player photo: 6 x 6 linear 4bpp tiles packed for DecompressHuffman, one
									;entry of the photo table
			;   in bank $9D
	db $30,$FB
	db $00,$04,$80
	incbin "../../../Extracted/data/gfx/PlayerCards/Card145.lin.huf":5..506
endmacro

; Player photo 146 (PlayerPhotoTable NYR 0)
macro Card146()
Card146:							;a player photo: 6 x 6 linear 4bpp tiles packed for DecompressHuffman, one
									;entry of the photo table
			;   in bank $9D
	db $30,$FB
	db $00,$04,$80
	incbin "../../../Extracted/data/gfx/PlayerCards/Card146.lin.huf":5..505
endmacro

; Player photo 147 (PlayerPhotoTable QUE 11)
macro Card147()
Card147:							;a player photo: 6 x 6 linear 4bpp tiles packed for DecompressHuffman, one
									;entry of the photo table
			;   in bank $9D
	db $30,$FB
	db $00,$04,$80
	incbin "../../../Extracted/data/gfx/PlayerCards/Card147.lin.huf":5..505
endmacro

; Player photo 148 (PlayerPhotoTable STL 0)
macro Card148()
Card148:							;a player photo: 6 x 6 linear 4bpp tiles packed for DecompressHuffman, one
									;entry of the photo table
			;   in bank $9D
	db $30,$FB
	db $00,$04,$80
	incbin "../../../Extracted/data/gfx/PlayerCards/Card148.lin.huf":5..503
endmacro

; Player photo 149 (PlayerPhotoTable DET 17; ASW 19)
macro Card149()
Card149:							;a player photo: 6 x 6 linear 4bpp tiles packed for DecompressHuffman, one
									;entry of the photo table
			;   in bank $9D
	db $30,$FB
	db $00,$04,$80
	incbin "../../../Extracted/data/gfx/PlayerCards/Card149.lin.huf":5..498
endmacro

; Player photo 150 (PlayerPhotoTable STL 1)
macro Card150()
Card150:							;a player photo: 6 x 6 linear 4bpp tiles packed for DecompressHuffman, one
									;entry of the photo table
			;   in bank $9D
	db $30,$FB
	db $00,$04,$80
	incbin "../../../Extracted/data/gfx/PlayerCards/Card150.lin.huf":5..483
	db $00
endmacro

; Player photo 151 (PlayerPhotoTable WPG 17; ASW 21)
macro Card151()
Card151:							;a player photo: 6 x 6 linear 4bpp tiles packed for DecompressHuffman, one
									;entry of the photo table
			;   in bank $9D
	db $30,$FB
	db $00,$04,$80
	incbin "../../../Extracted/data/gfx/PlayerCards/Card151.lin.huf":5..479
endmacro

; Player photo 152 (PlayerPhotoTable PIT 9; ASE 11)
macro Card152()
Card152:							;a player photo: 6 x 6 linear 4bpp tiles packed for DecompressHuffman, one
									;entry of the photo table
			;   in bank $9D
	db $30,$FB
	db $00,$04,$80
	incbin "../../../Extracted/data/gfx/PlayerCards/Card152.lin.huf":5..477
endmacro

; Player photo 153 (PlayerPhotoTable NJ 0)
macro Card153()
Card153:							;a player photo: 6 x 6 linear 4bpp tiles packed for DecompressHuffman, one
									;entry of the photo table
			;   in bank $9D
	db $30,$FB
	db $00,$04,$80
	incbin "../../../Extracted/data/gfx/PlayerCards/Card153.lin.huf":5..471
endmacro

; Player photo 154 (PlayerPhotoTable PIT 2; ASE 3)
macro Card154()
Card154:							;a player photo: 6 x 6 linear 4bpp tiles packed for DecompressHuffman, one
									;entry of the photo table
			;   in bank $9D
	db $30,$FB
	db $00,$04,$80
	incbin "../../../Extracted/data/gfx/PlayerCards/Card154.lin.huf":5..470
endmacro

; Player photo 155 (PlayerPhotoTable NJ 11)
macro Card155()
Card155:							;a player photo: 6 x 6 linear 4bpp tiles packed for DecompressHuffman, one
									;entry of the photo table
			;   in bank $9D
	db $30,$FB
	db $00,$04,$80
	incbin "../../../Extracted/data/gfx/PlayerCards/Card155.lin.huf":5..469
endmacro

; Player photo 156 (PlayerPhotoTable TOR 2; ASW 7)
macro Card156()
Card156:							;a player photo: 6 x 6 linear 4bpp tiles packed for DecompressHuffman, one
									;entry of the photo table
			;   in bank $9D
	db $30,$FB
	db $00,$04,$80
	incbin "../../../Extracted/data/gfx/PlayerCards/Card156.lin.huf":5..451
endmacro
