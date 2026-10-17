; SpriteFrames, the main sprite set DrawSprite uses: skaters, goalies, the nets, the puck, markers, the bench,
; the Zamboni, two sprite fonts and the hat trick hats. Frames are in the SPF groups of ram94snes.asm: frame
; SPFgroup+n is SpriteFrame_group_n. The offset table (one 4-byte offset per frame; the first offset ends the
; table) is followed by this bank's frames. A frame is the piece count, flags (bit 7: 16x16 tiles), tile
; count, the box of its pixels (left, right, top, bottom; nothing reads it), the two transfer sizes, the tile
; offset, the hot spot x / y (signed bytes, GetHot), the stick point x / y (GetFrameHot), the pieces, then the
; tiles.

SpriteFrames:						; frame offsets
	dd SpriteFrame_skatewp_0-SpriteFrames,SpriteFrame_skatewp_1-SpriteFrames,SpriteFrame_skatewp_2-SpriteFrames,SpriteFrame_skatewp_3-SpriteFrames
	dd SpriteFrame_skatewp_4-SpriteFrames,SpriteFrame_skatewp_5-SpriteFrames,SpriteFrame_skatewp_6-SpriteFrames,SpriteFrame_skatewp_7-SpriteFrames
	dd SpriteFrame_skatewp_8-SpriteFrames,SpriteFrame_skatewp_9-SpriteFrames,SpriteFrame_skatewp_10-SpriteFrames,SpriteFrame_skatewp_11-SpriteFrames
	dd SpriteFrame_skatewp_12-SpriteFrames,SpriteFrame_skatewp_13-SpriteFrames,SpriteFrame_skatewp_14-SpriteFrames,SpriteFrame_skatewp_15-SpriteFrames
	dd SpriteFrame_skatewp_16-SpriteFrames,SpriteFrame_skatewp_17-SpriteFrames,SpriteFrame_skatewp_18-SpriteFrames,SpriteFrame_skatewp_19-SpriteFrames
	dd SpriteFrame_skatewp_20-SpriteFrames,SpriteFrame_skatewp_21-SpriteFrames,SpriteFrame_skatewp_22-SpriteFrames,SpriteFrame_skatewp_23-SpriteFrames
	dd SpriteFrame_skatewp_24-SpriteFrames,SpriteFrame_skatewp_25-SpriteFrames,SpriteFrame_skatewp_26-SpriteFrames,SpriteFrame_skatewp_27-SpriteFrames
	dd SpriteFrame_skatewp_28-SpriteFrames,SpriteFrame_skatewp_29-SpriteFrames,SpriteFrame_skatewp_30-SpriteFrames,SpriteFrame_skatewp_31-SpriteFrames
	dd SpriteFrame_skatewp_32-SpriteFrames,SpriteFrame_skatewp_33-SpriteFrames,SpriteFrame_skatewp_34-SpriteFrames,SpriteFrame_skatewp_35-SpriteFrames
	dd SpriteFrame_skatewp_36-SpriteFrames,SpriteFrame_skatewp_37-SpriteFrames,SpriteFrame_skatewp_38-SpriteFrames,SpriteFrame_skatewp_39-SpriteFrames
	dd SpriteFrame_skate_0-SpriteFrames,SpriteFrame_skate_1-SpriteFrames,SpriteFrame_skate_2-SpriteFrames,SpriteFrame_skate_3-SpriteFrames
	dd SpriteFrame_skate_4-SpriteFrames,SpriteFrame_skate_5-SpriteFrames,SpriteFrame_skate_6-SpriteFrames,SpriteFrame_skate_7-SpriteFrames
	dd SpriteFrame_skate_8-SpriteFrames,SpriteFrame_skate_9-SpriteFrames,SpriteFrame_skate_10-SpriteFrames,SpriteFrame_skate_11-SpriteFrames
	dd SpriteFrame_skate_12-SpriteFrames,SpriteFrame_skate_13-SpriteFrames,SpriteFrame_skate_14-SpriteFrames,SpriteFrame_skate_15-SpriteFrames
	dd SpriteFrame_skate_16-SpriteFrames,SpriteFrame_skate_17-SpriteFrames,SpriteFrame_skate_18-SpriteFrames,SpriteFrame_skate_19-SpriteFrames
	dd SpriteFrame_skate_20-SpriteFrames,SpriteFrame_skate_21-SpriteFrames,SpriteFrame_skate_22-SpriteFrames,SpriteFrame_skate_23-SpriteFrames
	dd SpriteFrame_skate_24-SpriteFrames,SpriteFrame_skate_25-SpriteFrames,SpriteFrame_skate_26-SpriteFrames,SpriteFrame_skate_27-SpriteFrames
	dd SpriteFrame_skate_28-SpriteFrames,SpriteFrame_skate_29-SpriteFrames,SpriteFrame_skate_30-SpriteFrames,SpriteFrame_skate_31-SpriteFrames
	dd SpriteFrame_skate_32-SpriteFrames,SpriteFrame_skate_33-SpriteFrames,SpriteFrame_skate_34-SpriteFrames,SpriteFrame_skate_35-SpriteFrames
	dd SpriteFrame_skate_36-SpriteFrames,SpriteFrame_skate_37-SpriteFrames,SpriteFrame_skate_38-SpriteFrames,SpriteFrame_skate_39-SpriteFrames
	dd SpriteFrame_turnl_0-SpriteFrames,SpriteFrame_turnl_1-SpriteFrames,SpriteFrame_turnl_2-SpriteFrames,SpriteFrame_turnl_3-SpriteFrames
	dd SpriteFrame_turnl_4-SpriteFrames,SpriteFrame_turnl_5-SpriteFrames,SpriteFrame_turnl_6-SpriteFrames,SpriteFrame_turnl_7-SpriteFrames
	dd SpriteFrame_turnr_0-SpriteFrames,SpriteFrame_turnr_1-SpriteFrames,SpriteFrame_turnr_2-SpriteFrames,SpriteFrame_turnr_3-SpriteFrames
	dd SpriteFrame_turnr_4-SpriteFrames,SpriteFrame_turnr_5-SpriteFrames,SpriteFrame_turnr_6-SpriteFrames,SpriteFrame_turnr_7-SpriteFrames
	dd SpriteFrame_swing_0-SpriteFrames,SpriteFrame_swing_1-SpriteFrames,SpriteFrame_swing_2-SpriteFrames,SpriteFrame_swing_3-SpriteFrames
	dd SpriteFrame_swing_4-SpriteFrames,SpriteFrame_swing_5-SpriteFrames,SpriteFrame_swing_6-SpriteFrames,SpriteFrame_swing_7-SpriteFrames
	dd SpriteFrame_swing_8-SpriteFrames,SpriteFrame_swing_9-SpriteFrames,SpriteFrame_swing_10-SpriteFrames,SpriteFrame_swing_11-SpriteFrames
	dd SpriteFrame_swing_12-SpriteFrames,SpriteFrame_swing_13-SpriteFrames,SpriteFrame_swing_14-SpriteFrames,SpriteFrame_swing_15-SpriteFrames
	dd SpriteFrame_swing_16-SpriteFrames,SpriteFrame_swing_17-SpriteFrames,SpriteFrame_swing_18-SpriteFrames,SpriteFrame_swing_19-SpriteFrames
	dd SpriteFrame_swing_20-SpriteFrames,SpriteFrame_swing_21-SpriteFrames,SpriteFrame_swing_22-SpriteFrames,SpriteFrame_swing_23-SpriteFrames
	dd SpriteFrame_swing_24-SpriteFrames,SpriteFrame_swing_25-SpriteFrames,SpriteFrame_swing_26-SpriteFrames,SpriteFrame_swing_27-SpriteFrames
	dd SpriteFrame_swing_28-SpriteFrames,SpriteFrame_swing_29-SpriteFrames,SpriteFrame_swing_30-SpriteFrames,SpriteFrame_swing_31-SpriteFrames
	dd SpriteFrame_swing_32-SpriteFrames,SpriteFrame_swing_33-SpriteFrames,SpriteFrame_swing_34-SpriteFrames,SpriteFrame_swing_35-SpriteFrames
	dd SpriteFrame_swing_36-SpriteFrames,SpriteFrame_swing_37-SpriteFrames,SpriteFrame_swing_38-SpriteFrames,SpriteFrame_swing_39-SpriteFrames
	dd SpriteFrame_swing_40-SpriteFrames,SpriteFrame_swing_41-SpriteFrames,SpriteFrame_swing_42-SpriteFrames,SpriteFrame_swing_43-SpriteFrames
	dd SpriteFrame_swing_44-SpriteFrames,SpriteFrame_swing_45-SpriteFrames,SpriteFrame_swing_46-SpriteFrames,SpriteFrame_swing_47-SpriteFrames
	dd SpriteFrame_stop_0-SpriteFrames,SpriteFrame_stop_1-SpriteFrames,SpriteFrame_stop_2-SpriteFrames,SpriteFrame_stop_3-SpriteFrames
	dd SpriteFrame_stop_4-SpriteFrames,SpriteFrame_stop_5-SpriteFrames,SpriteFrame_stop_6-SpriteFrames,SpriteFrame_stop_7-SpriteFrames
	dd SpriteFrame_stop_8-SpriteFrames,SpriteFrame_stop_9-SpriteFrames,SpriteFrame_stop_10-SpriteFrames,SpriteFrame_stop_11-SpriteFrames
	dd SpriteFrame_stop_12-SpriteFrames,SpriteFrame_stop_13-SpriteFrames,SpriteFrame_stop_14-SpriteFrames,SpriteFrame_stop_15-SpriteFrames
	dd SpriteFrame_skateb_0-SpriteFrames,SpriteFrame_skateb_1-SpriteFrames,SpriteFrame_skateb_2-SpriteFrames,SpriteFrame_skateb_3-SpriteFrames
	dd SpriteFrame_skateb_4-SpriteFrames,SpriteFrame_skateb_5-SpriteFrames,SpriteFrame_skateb_6-SpriteFrames,SpriteFrame_skateb_7-SpriteFrames
	dd SpriteFrame_skateb_8-SpriteFrames,SpriteFrame_skateb_9-SpriteFrames,SpriteFrame_skateb_10-SpriteFrames,SpriteFrame_skateb_11-SpriteFrames
	dd SpriteFrame_skateb_12-SpriteFrames,SpriteFrame_skateb_13-SpriteFrames,SpriteFrame_skateb_14-SpriteFrames,SpriteFrame_skateb_15-SpriteFrames
	dd SpriteFrame_skateb_16-SpriteFrames,SpriteFrame_skateb_17-SpriteFrames,SpriteFrame_skateb_18-SpriteFrames,SpriteFrame_skateb_19-SpriteFrames
	dd SpriteFrame_skateb_20-SpriteFrames,SpriteFrame_skateb_21-SpriteFrames,SpriteFrame_skateb_22-SpriteFrames,SpriteFrame_skateb_23-SpriteFrames
	dd SpriteFrame_celebrate_0-SpriteFrames,SpriteFrame_celebrate_1-SpriteFrames,SpriteFrame_celebrate_2-SpriteFrames,SpriteFrame_celebrate_3-SpriteFrames
	dd SpriteFrame_celebrate_4-SpriteFrames,SpriteFrame_celebrate_5-SpriteFrames,SpriteFrame_celebrate_6-SpriteFrames,SpriteFrame_celebrate_7-SpriteFrames
	dd SpriteFrame_celebrate_8-SpriteFrames,SpriteFrame_celebrate_9-SpriteFrames,SpriteFrame_celebrate_10-SpriteFrames,SpriteFrame_celebrate_11-SpriteFrames
	dd SpriteFrame_celebrate_12-SpriteFrames,SpriteFrame_celebrate_13-SpriteFrames,SpriteFrame_celebrate_14-SpriteFrames,SpriteFrame_celebrate_15-SpriteFrames
	dd SpriteFrame_pump_0-SpriteFrames,SpriteFrame_pump_1-SpriteFrames,SpriteFrame_pump_2-SpriteFrames,SpriteFrame_pump_3-SpriteFrames
	dd SpriteFrame_pump_4-SpriteFrames,SpriteFrame_pump_5-SpriteFrames,SpriteFrame_pump_6-SpriteFrames,SpriteFrame_pump_7-SpriteFrames
	dd SpriteFrame_pump_8-SpriteFrames,SpriteFrame_pump_9-SpriteFrames,SpriteFrame_pump_10-SpriteFrames,SpriteFrame_pump_11-SpriteFrames
	dd SpriteFrame_pump_12-SpriteFrames,SpriteFrame_pump_13-SpriteFrames,SpriteFrame_pump_14-SpriteFrames,SpriteFrame_pump_15-SpriteFrames
	dd SpriteFrame_cup_0-SpriteFrames,SpriteFrame_cup_1-SpriteFrames,SpriteFrame_cup_2-SpriteFrames,SpriteFrame_cup_3-SpriteFrames
	dd SpriteFrame_cup_4-SpriteFrames,SpriteFrame_cup_5-SpriteFrames,SpriteFrame_cup_6-SpriteFrames,SpriteFrame_cup_7-SpriteFrames
	dd SpriteFrame_cupover_0-SpriteFrames,SpriteFrame_cupover_1-SpriteFrames,SpriteFrame_cupover_2-SpriteFrames,SpriteFrame_cupover_3-SpriteFrames
	dd SpriteFrame_cupover_4-SpriteFrames,SpriteFrame_cupover_5-SpriteFrames,SpriteFrame_cupover_6-SpriteFrames,SpriteFrame_cupover_7-SpriteFrames
	dd SpriteFrame_hipl_0-SpriteFrames,SpriteFrame_hipl_1-SpriteFrames,SpriteFrame_hipl_2-SpriteFrames,SpriteFrame_hipl_3-SpriteFrames
	dd SpriteFrame_hipl_4-SpriteFrames,SpriteFrame_hipl_5-SpriteFrames,SpriteFrame_hipl_6-SpriteFrames,SpriteFrame_hipl_7-SpriteFrames
	dd SpriteFrame_hipr_0-SpriteFrames,SpriteFrame_hipr_1-SpriteFrames,SpriteFrame_hipr_2-SpriteFrames,SpriteFrame_hipr_3-SpriteFrames
	dd SpriteFrame_hipr_4-SpriteFrames,SpriteFrame_hipr_5-SpriteFrames,SpriteFrame_hipr_6-SpriteFrames,SpriteFrame_hipr_7-SpriteFrames
	dd SpriteFrame_shoulderl_0-SpriteFrames,SpriteFrame_shoulderl_1-SpriteFrames,SpriteFrame_shoulderl_2-SpriteFrames,SpriteFrame_shoulderl_3-SpriteFrames
	dd SpriteFrame_shoulderl_4-SpriteFrames,SpriteFrame_shoulderl_5-SpriteFrames,SpriteFrame_shoulderl_6-SpriteFrames,SpriteFrame_shoulderl_7-SpriteFrames
	dd SpriteFrame_shoulderr_0-SpriteFrames,SpriteFrame_shoulderr_1-SpriteFrames,SpriteFrame_shoulderr_2-SpriteFrames,SpriteFrame_shoulderr_3-SpriteFrames
	dd SpriteFrame_shoulderr_4-SpriteFrames,SpriteFrame_shoulderr_5-SpriteFrames,SpriteFrame_shoulderr_6-SpriteFrames,SpriteFrame_shoulderr_7-SpriteFrames
	dd SpriteFrame_sweep_0-SpriteFrames,SpriteFrame_sweep_1-SpriteFrames,SpriteFrame_sweep_2-SpriteFrames,SpriteFrame_sweep_3-SpriteFrames
	dd SpriteFrame_sweep_4-SpriteFrames,SpriteFrame_sweep_5-SpriteFrames,SpriteFrame_sweep_6-SpriteFrames,SpriteFrame_sweep_7-SpriteFrames
	dd SpriteFrame_sweep_8-SpriteFrames,SpriteFrame_sweep_9-SpriteFrames,SpriteFrame_sweep_10-SpriteFrames,SpriteFrame_sweep_11-SpriteFrames
	dd SpriteFrame_sweep_12-SpriteFrames,SpriteFrame_sweep_13-SpriteFrames,SpriteFrame_sweep_14-SpriteFrames,SpriteFrame_sweep_15-SpriteFrames
	dd SpriteFrame_fallback_0-SpriteFrames,SpriteFrame_fallback_1-SpriteFrames,SpriteFrame_fallback_2-SpriteFrames,SpriteFrame_fallback_3-SpriteFrames
	dd SpriteFrame_fallback_4-SpriteFrames,SpriteFrame_fallback_5-SpriteFrames,SpriteFrame_fallback_6-SpriteFrames,SpriteFrame_fallback_7-SpriteFrames
	dd SpriteFrame_fallback_8-SpriteFrames,SpriteFrame_fallback_9-SpriteFrames,SpriteFrame_fallback_10-SpriteFrames,SpriteFrame_fallback_11-SpriteFrames
	dd SpriteFrame_fallback_12-SpriteFrames,SpriteFrame_fallback_13-SpriteFrames,SpriteFrame_fallback_14-SpriteFrames,SpriteFrame_fallback_15-SpriteFrames
	dd SpriteFrame_fallback_16-SpriteFrames,SpriteFrame_fallback_17-SpriteFrames,SpriteFrame_fallback_18-SpriteFrames,SpriteFrame_fallback_19-SpriteFrames
	dd SpriteFrame_fallback_20-SpriteFrames,SpriteFrame_fallback_21-SpriteFrames,SpriteFrame_fallback_22-SpriteFrames,SpriteFrame_fallback_23-SpriteFrames
	dd SpriteFrame_fallback_24-SpriteFrames,SpriteFrame_fallback_25-SpriteFrames,SpriteFrame_fallback_26-SpriteFrames,SpriteFrame_fallback_27-SpriteFrames
	dd SpriteFrame_fallback_28-SpriteFrames,SpriteFrame_fallback_29-SpriteFrames,SpriteFrame_fallback_30-SpriteFrames,SpriteFrame_fallback_31-SpriteFrames
	dd SpriteFrame_fallfwd_0-SpriteFrames,SpriteFrame_fallfwd_1-SpriteFrames,SpriteFrame_fallfwd_2-SpriteFrames,SpriteFrame_fallfwd_3-SpriteFrames
	dd SpriteFrame_fallfwd_4-SpriteFrames,SpriteFrame_fallfwd_5-SpriteFrames,SpriteFrame_fallfwd_6-SpriteFrames,SpriteFrame_fallfwd_7-SpriteFrames
	dd SpriteFrame_fallfwd_8-SpriteFrames,SpriteFrame_fallfwd_9-SpriteFrames,SpriteFrame_fallfwd_10-SpriteFrames,SpriteFrame_fallfwd_11-SpriteFrames
	dd SpriteFrame_fallfwd_12-SpriteFrames,SpriteFrame_fallfwd_13-SpriteFrames,SpriteFrame_fallfwd_14-SpriteFrames,SpriteFrame_fallfwd_15-SpriteFrames
	dd SpriteFrame_fallfwd_16-SpriteFrames,SpriteFrame_fallfwd_17-SpriteFrames,SpriteFrame_fallfwd_18-SpriteFrames,SpriteFrame_fallfwd_19-SpriteFrames
	dd SpriteFrame_fallfwd_20-SpriteFrames,SpriteFrame_fallfwd_21-SpriteFrames,SpriteFrame_fallfwd_22-SpriteFrames,SpriteFrame_fallfwd_23-SpriteFrames
	dd SpriteFrame_fallfwd_24-SpriteFrames,SpriteFrame_fallfwd_25-SpriteFrames,SpriteFrame_fallfwd_26-SpriteFrames,SpriteFrame_fallfwd_27-SpriteFrames
	dd SpriteFrame_fallfwd_28-SpriteFrames,SpriteFrame_fallfwd_29-SpriteFrames,SpriteFrame_fallfwd_30-SpriteFrames,SpriteFrame_fallfwd_31-SpriteFrames
	dd SpriteFrame_duck_0-SpriteFrames,SpriteFrame_duck_1-SpriteFrames,SpriteFrame_duck_2-SpriteFrames,SpriteFrame_duck_3-SpriteFrames
	dd SpriteFrame_duck_4-SpriteFrames,SpriteFrame_duck_5-SpriteFrames,SpriteFrame_duck_6-SpriteFrames,SpriteFrame_duck_7-SpriteFrames
	dd SpriteFrame_hold_0-SpriteFrames,SpriteFrame_hold_1-SpriteFrames,SpriteFrame_hold_2-SpriteFrames,SpriteFrame_hold_3-SpriteFrames
	dd SpriteFrame_hold_4-SpriteFrames,SpriteFrame_hold_5-SpriteFrames,SpriteFrame_hold_6-SpriteFrames,SpriteFrame_hold_7-SpriteFrames
	dd SpriteFrame_Pen_0-SpriteFrames,SpriteFrame_Pen_1-SpriteFrames,SpriteFrame_Pen_2-SpriteFrames,SpriteFrame_Pen_3-SpriteFrames
	dd SpriteFrame_Pen_4-SpriteFrames,SpriteFrame_Pen_5-SpriteFrames,SpriteFrame_Pen_6-SpriteFrames,SpriteFrame_Pen_7-SpriteFrames
	dd SpriteFrame_Pen_8-SpriteFrames,SpriteFrame_gwall_0-SpriteFrames,SpriteFrame_gwall_1-SpriteFrames,SpriteFrame_gwall_2-SpriteFrames
	dd SpriteFrame_gwall_3-SpriteFrames,SpriteFrame_arrow_0-SpriteFrames,SpriteFrame_arrow_1-SpriteFrames,SpriteFrame_arrow_2-SpriteFrames
	dd SpriteFrame_arrow_3-SpriteFrames,SpriteFrame_arrow_4-SpriteFrames,SpriteFrame_arrow_5-SpriteFrames,SpriteFrame_arrow_6-SpriteFrames
	dd SpriteFrame_arrow_7-SpriteFrames,SpriteFrame_arrow_8-SpriteFrames,SpriteFrame_arrow_9-SpriteFrames,SpriteFrame_arrow_10-SpriteFrames
	dd SpriteFrame_arrow_11-SpriteFrames,SpriteFrame_arrow_12-SpriteFrames,SpriteFrame_arrow_13-SpriteFrames,SpriteFrame_arrow_14-SpriteFrames
	dd SpriteFrame_pad_0-SpriteFrames,SpriteFrame_pad_1-SpriteFrames,SpriteFrame_pad_2-SpriteFrames,SpriteFrame_pad_3-SpriteFrames
	dd SpriteFrame_pad_4-SpriteFrames,SpriteFrame_pad_5-SpriteFrames,SpriteFrame_replay_0-SpriteFrames,SpriteFrame_puck_0-SpriteFrames
	dd SpriteFrame_puck_1-SpriteFrames,SpriteFrame_puck_2-SpriteFrames,SpriteFrame_puck_3-SpriteFrames,SpriteFrame_puck_4-SpriteFrames
	dd SpriteFrame_puck_5-SpriteFrames,SpriteFrame_puck_6-SpriteFrames,SpriteFrame_puck_7-SpriteFrames,SpriteFrame_puck_8-SpriteFrames
	dd SpriteFrame_puck_9-SpriteFrames,SpriteFrame_puck_10-SpriteFrames,SpriteFrame_goal_0-SpriteFrames,SpriteFrame_goal_1-SpriteFrames
	dd SpriteFrame_Siren_0-SpriteFrames,SpriteFrame_Siren_1-SpriteFrames,SpriteFrame_Siren_2-SpriteFrames,SpriteFrame_Siren_3-SpriteFrames
	dd SpriteFrame_Siren_4-SpriteFrames,SpriteFrame_Siren_5-SpriteFrames,SpriteFrame_Siren_6-SpriteFrames,SpriteFrame_Siren_7-SpriteFrames
	dd SpriteFrame_Siren_8-SpriteFrames,SpriteFrame_Siren_9-SpriteFrames,SpriteFrame_Siren_10-SpriteFrames,SpriteFrame_Siren_11-SpriteFrames
	dd SpriteFrame_Siren_12-SpriteFrames,SpriteFrame_Siren_13-SpriteFrames,SpriteFrame_faceoff_0-SpriteFrames,SpriteFrame_faceoff_1-SpriteFrames
	dd SpriteFrame_faceoff_2-SpriteFrames,SpriteFrame_faceoff_3-SpriteFrames,SpriteFrame_faceoff_4-SpriteFrames,SpriteFrame_faceoff_5-SpriteFrames
	dd SpriteFrame_faceoff_6-SpriteFrames,SpriteFrame_faceoff_7-SpriteFrames,SpriteFrame_faceoff_8-SpriteFrames,SpriteFrame_faceoff_9-SpriteFrames
	dd SpriteFrame_smallfont_0-SpriteFrames,SpriteFrame_smallfont_1-SpriteFrames,SpriteFrame_smallfont_2-SpriteFrames,SpriteFrame_smallfont_3-SpriteFrames
	dd SpriteFrame_smallfont_4-SpriteFrames,SpriteFrame_smallfont_5-SpriteFrames,SpriteFrame_smallfont_6-SpriteFrames,SpriteFrame_smallfont_7-SpriteFrames
	dd SpriteFrame_smallfont_8-SpriteFrames,SpriteFrame_smallfont_9-SpriteFrames,SpriteFrame_smallfont_10-SpriteFrames,SpriteFrame_smallfont_11-SpriteFrames
	dd SpriteFrame_smallfont_12-SpriteFrames,SpriteFrame_smallfont_13-SpriteFrames,SpriteFrame_smallfont_14-SpriteFrames,SpriteFrame_zamboni_0-SpriteFrames
	dd SpriteFrame_flip_0-SpriteFrames,SpriteFrame_flip_1-SpriteFrames,SpriteFrame_flip_2-SpriteFrames,SpriteFrame_flip_3-SpriteFrames
	dd SpriteFrame_flip_4-SpriteFrames,SpriteFrame_flip_5-SpriteFrames,SpriteFrame_flip_6-SpriteFrames,SpriteFrame_flip_7-SpriteFrames
	dd SpriteFrame_stumble_0-SpriteFrames,SpriteFrame_stumble_1-SpriteFrames,SpriteFrame_stumble_2-SpriteFrames,SpriteFrame_stumble_3-SpriteFrames
	dd SpriteFrame_stumble_4-SpriteFrames,SpriteFrame_stumble_5-SpriteFrames,SpriteFrame_stumble_6-SpriteFrames,SpriteFrame_stumble_7-SpriteFrames
	dd SpriteFrame_stumble_8-SpriteFrames,SpriteFrame_stumble_9-SpriteFrames,SpriteFrame_stumble_10-SpriteFrames,SpriteFrame_stumble_11-SpriteFrames
	dd SpriteFrame_stumble_12-SpriteFrames,SpriteFrame_stumble_13-SpriteFrames,SpriteFrame_stumble_14-SpriteFrames,SpriteFrame_stumble_15-SpriteFrames
	dd SpriteFrame_stumble_16-SpriteFrames,SpriteFrame_stumble_17-SpriteFrames,SpriteFrame_stumble_18-SpriteFrames,SpriteFrame_stumble_19-SpriteFrames
	dd SpriteFrame_stumble_20-SpriteFrames,SpriteFrame_stumble_21-SpriteFrames,SpriteFrame_stumble_22-SpriteFrames,SpriteFrame_stumble_23-SpriteFrames
	dd SpriteFrame_hook_0-SpriteFrames,SpriteFrame_hook_1-SpriteFrames,SpriteFrame_hook_2-SpriteFrames,SpriteFrame_hook_3-SpriteFrames
	dd SpriteFrame_hook_4-SpriteFrames,SpriteFrame_hook_5-SpriteFrames,SpriteFrame_hook_6-SpriteFrames,SpriteFrame_hook_7-SpriteFrames
	dd SpriteFrame_hook_8-SpriteFrames,SpriteFrame_hook_9-SpriteFrames,SpriteFrame_hook_10-SpriteFrames,SpriteFrame_hook_11-SpriteFrames
	dd SpriteFrame_hook_12-SpriteFrames,SpriteFrame_hook_13-SpriteFrames,SpriteFrame_hook_14-SpriteFrames,SpriteFrame_hook_15-SpriteFrames
	dd SpriteFrame_catch_0-SpriteFrames,SpriteFrame_catch_1-SpriteFrames,SpriteFrame_catch_2-SpriteFrames,SpriteFrame_catch_3-SpriteFrames
	dd SpriteFrame_catch_4-SpriteFrames,SpriteFrame_catch_5-SpriteFrames,SpriteFrame_catch_6-SpriteFrames,SpriteFrame_catch_7-SpriteFrames
	dd SpriteFrame_catch_8-SpriteFrames,SpriteFrame_catch_9-SpriteFrames,SpriteFrame_catch_10-SpriteFrames,SpriteFrame_catch_11-SpriteFrames
	dd SpriteFrame_catch_12-SpriteFrames,SpriteFrame_catch_13-SpriteFrames,SpriteFrame_catch_14-SpriteFrames,SpriteFrame_catch_15-SpriteFrames
	dd SpriteFrame_bglass_0-SpriteFrames,SpriteFrame_bglass_1-SpriteFrames,SpriteFrame_bglass_2-SpriteFrames,SpriteFrame_bglass_3-SpriteFrames
	dd SpriteFrame_bglass_4-SpriteFrames,SpriteFrame_crosscheck_0-SpriteFrames,SpriteFrame_crosscheck_1-SpriteFrames,SpriteFrame_crosscheck_2-SpriteFrames
	dd SpriteFrame_crosscheck_3-SpriteFrames,SpriteFrame_crosscheck_4-SpriteFrames,SpriteFrame_crosscheck_5-SpriteFrames,SpriteFrame_crosscheck_6-SpriteFrames
	dd SpriteFrame_crosscheck_7-SpriteFrames,SpriteFrame_crosscheck_8-SpriteFrames,SpriteFrame_crosscheck_9-SpriteFrames,SpriteFrame_crosscheck_10-SpriteFrames
	dd SpriteFrame_crosscheck_11-SpriteFrames,SpriteFrame_crosscheck_12-SpriteFrames,SpriteFrame_crosscheck_13-SpriteFrames,SpriteFrame_crosscheck_14-SpriteFrames
	dd SpriteFrame_crosscheck_15-SpriteFrames,SpriteFrame_Goalie_0-SpriteFrames,SpriteFrame_Goalie_1-SpriteFrames,SpriteFrame_Goalie_2-SpriteFrames
	dd SpriteFrame_Goalie_3-SpriteFrames,SpriteFrame_Goalie_4-SpriteFrames,SpriteFrame_Goalie_5-SpriteFrames,SpriteFrame_Goalie_6-SpriteFrames
	dd SpriteFrame_Goalie_7-SpriteFrames,SpriteFrame_Goalie_8-SpriteFrames,SpriteFrame_Goalie_9-SpriteFrames,SpriteFrame_Goalie_10-SpriteFrames
	dd SpriteFrame_Goalie_11-SpriteFrames,SpriteFrame_Goalie_12-SpriteFrames,SpriteFrame_Goalie_13-SpriteFrames,SpriteFrame_Goalie_14-SpriteFrames
	dd SpriteFrame_Goalie_15-SpriteFrames,SpriteFrame_Goalie_16-SpriteFrames,SpriteFrame_Goalie_17-SpriteFrames,SpriteFrame_Goalie_18-SpriteFrames
	dd SpriteFrame_Goalie_19-SpriteFrames,SpriteFrame_Goalie_20-SpriteFrames,SpriteFrame_Goalie_21-SpriteFrames,SpriteFrame_Goalie_22-SpriteFrames
	dd SpriteFrame_Goalie_23-SpriteFrames,SpriteFrame_Goalie_24-SpriteFrames,SpriteFrame_Goalie_25-SpriteFrames,SpriteFrame_Goalie_26-SpriteFrames
	dd SpriteFrame_Goalie_27-SpriteFrames,SpriteFrame_Goalie_28-SpriteFrames,SpriteFrame_Goalie_29-SpriteFrames,SpriteFrame_Goalie_30-SpriteFrames
	dd SpriteFrame_Goalie_31-SpriteFrames,SpriteFrame_Goalie_32-SpriteFrames,SpriteFrame_Goalie_33-SpriteFrames,SpriteFrame_Goalie_34-SpriteFrames
	dd SpriteFrame_Goalie_35-SpriteFrames,SpriteFrame_Goalie_36-SpriteFrames,SpriteFrame_Goalie_37-SpriteFrames,SpriteFrame_Goalie_38-SpriteFrames
	dd SpriteFrame_Goalie_39-SpriteFrames,SpriteFrame_Goalie_40-SpriteFrames,SpriteFrame_Goalie_41-SpriteFrames,SpriteFrame_Goalie_42-SpriteFrames
	dd SpriteFrame_Goalie_43-SpriteFrames,SpriteFrame_Goalie_44-SpriteFrames,SpriteFrame_Goalie_45-SpriteFrames,SpriteFrame_Goalie_46-SpriteFrames
	dd SpriteFrame_Goalie_47-SpriteFrames,SpriteFrame_Goalie_48-SpriteFrames,SpriteFrame_Goalie_49-SpriteFrames,SpriteFrame_Goalie_50-SpriteFrames
	dd SpriteFrame_Goalie_51-SpriteFrames,SpriteFrame_Goalie_52-SpriteFrames,SpriteFrame_Goalie_53-SpriteFrames,SpriteFrame_Goalie_54-SpriteFrames
	dd SpriteFrame_Goalie_55-SpriteFrames,SpriteFrame_Goalie_56-SpriteFrames,SpriteFrame_Goalie_57-SpriteFrames,SpriteFrame_Goalie_58-SpriteFrames
	dd SpriteFrame_Goalie_59-SpriteFrames,SpriteFrame_Goalie_60-SpriteFrames,SpriteFrame_Goalie_61-SpriteFrames,SpriteFrame_Goalie_62-SpriteFrames
	dd SpriteFrame_Goalie_63-SpriteFrames,SpriteFrame_Goalie_64-SpriteFrames,SpriteFrame_Goalie_65-SpriteFrames,SpriteFrame_Goalie_66-SpriteFrames
	dd SpriteFrame_Goalie_67-SpriteFrames,SpriteFrame_Goalie_68-SpriteFrames,SpriteFrame_Goalie_69-SpriteFrames,SpriteFrame_Goalie_70-SpriteFrames
	dd SpriteFrame_Goalie_71-SpriteFrames,SpriteFrame_Goalie_72-SpriteFrames,SpriteFrame_Goalie_73-SpriteFrames,SpriteFrame_Goalie_74-SpriteFrames
	dd SpriteFrame_Goalie_75-SpriteFrames,SpriteFrame_Goalie_76-SpriteFrames,SpriteFrame_Goalie_77-SpriteFrames,SpriteFrame_Goalie_78-SpriteFrames
	dd SpriteFrame_Goalie_79-SpriteFrames,SpriteFrame_Goalie_80-SpriteFrames,SpriteFrame_Goalie_81-SpriteFrames,SpriteFrame_Goalie_82-SpriteFrames
	dd SpriteFrame_Goalie_83-SpriteFrames,SpriteFrame_Goalie_84-SpriteFrames,SpriteFrame_Goalie_85-SpriteFrames,SpriteFrame_Goalie_86-SpriteFrames
	dd SpriteFrame_Goalie_87-SpriteFrames,SpriteFrame_Goalie_88-SpriteFrames,SpriteFrame_Goalie_89-SpriteFrames,SpriteFrame_Goalie_90-SpriteFrames
	dd SpriteFrame_Goalie_91-SpriteFrames,SpriteFrame_Goalie_92-SpriteFrames,SpriteFrame_Goalie_93-SpriteFrames,SpriteFrame_Goalie_94-SpriteFrames
	dd SpriteFrame_Goalie_95-SpriteFrames,SpriteFrame_Goalie_96-SpriteFrames,SpriteFrame_Goalie_97-SpriteFrames,SpriteFrame_Goalie_98-SpriteFrames
	dd SpriteFrame_Goalie_99-SpriteFrames,SpriteFrame_Goalie_100-SpriteFrames,SpriteFrame_Goalie_101-SpriteFrames,SpriteFrame_Goalie_102-SpriteFrames
	dd SpriteFrame_Goalie_103-SpriteFrames,SpriteFrame_Goalie_104-SpriteFrames,SpriteFrame_Goalie_105-SpriteFrames,SpriteFrame_Goalie_106-SpriteFrames
	dd SpriteFrame_Goalie_107-SpriteFrames,SpriteFrame_Goalie_108-SpriteFrames,SpriteFrame_Goalie_109-SpriteFrames,SpriteFrame_Goalie_110-SpriteFrames
	dd SpriteFrame_Goalie_111-SpriteFrames,SpriteFrame_gready_0-SpriteFrames,SpriteFrame_gready_1-SpriteFrames,SpriteFrame_gready_2-SpriteFrames
	dd SpriteFrame_gready_3-SpriteFrames,SpriteFrame_gready_4-SpriteFrames,SpriteFrame_gready_5-SpriteFrames,SpriteFrame_gready_6-SpriteFrames
	dd SpriteFrame_gready_7-SpriteFrames,SpriteFrame_gready_8-SpriteFrames,SpriteFrame_gready_9-SpriteFrames,SpriteFrame_gready_10-SpriteFrames
	dd SpriteFrame_gready_11-SpriteFrames,SpriteFrame_gready_12-SpriteFrames,SpriteFrame_gready_13-SpriteFrames,SpriteFrame_gready_14-SpriteFrames
	dd SpriteFrame_gready_15-SpriteFrames,SpriteFrame_gdive_0-SpriteFrames,SpriteFrame_gdive_1-SpriteFrames,SpriteFrame_gdive_2-SpriteFrames
	dd SpriteFrame_gdive_3-SpriteFrames,SpriteFrame_gdive_4-SpriteFrames,SpriteFrame_gdive_5-SpriteFrames,SpriteFrame_gdive_6-SpriteFrames
	dd SpriteFrame_gdive_7-SpriteFrames,SpriteFrame_gdive_8-SpriteFrames,SpriteFrame_gdive_9-SpriteFrames,SpriteFrame_gdive_10-SpriteFrames
	dd SpriteFrame_gdive_11-SpriteFrames,SpriteFrame_gdive_12-SpriteFrames,SpriteFrame_gdive_13-SpriteFrames,SpriteFrame_gdive_14-SpriteFrames
	dd SpriteFrame_gdive_15-SpriteFrames,SpriteFrame_gpoke_0-SpriteFrames,SpriteFrame_gpoke_1-SpriteFrames,SpriteFrame_gpoke_2-SpriteFrames
	dd SpriteFrame_gpoke_3-SpriteFrames,SpriteFrame_gpoke_4-SpriteFrames,SpriteFrame_gpoke_5-SpriteFrames,SpriteFrame_gpoke_6-SpriteFrames
	dd SpriteFrame_gpoke_7-SpriteFrames,SpriteFrame_gpoke_8-SpriteFrames,SpriteFrame_gpoke_9-SpriteFrames,SpriteFrame_gpoke_10-SpriteFrames
	dd SpriteFrame_gpoke_11-SpriteFrames,SpriteFrame_gpoke_12-SpriteFrames,SpriteFrame_gpoke_13-SpriteFrames,SpriteFrame_gpoke_14-SpriteFrames
	dd SpriteFrame_gpoke_15-SpriteFrames,SpriteFrame_gcover_0-SpriteFrames,SpriteFrame_gcover_1-SpriteFrames,SpriteFrame_gcover_2-SpriteFrames
	dd SpriteFrame_gcover_3-SpriteFrames,SpriteFrame_gcover_4-SpriteFrames,SpriteFrame_gcover_5-SpriteFrames,SpriteFrame_gcover_6-SpriteFrames
	dd SpriteFrame_gcover_7-SpriteFrames,SpriteFrame_gcover_8-SpriteFrames,SpriteFrame_gcover_9-SpriteFrames,SpriteFrame_gcover_10-SpriteFrames
	dd SpriteFrame_gcover_11-SpriteFrames,SpriteFrame_gcover_12-SpriteFrames,SpriteFrame_gcover_13-SpriteFrames,SpriteFrame_gcover_14-SpriteFrames
	dd SpriteFrame_gcover_15-SpriteFrames,SpriteFrame_gcover_16-SpriteFrames,SpriteFrame_gcover_17-SpriteFrames,SpriteFrame_gcover_18-SpriteFrames
	dd SpriteFrame_gcover_19-SpriteFrames,SpriteFrame_gcover_20-SpriteFrames,SpriteFrame_gcover_21-SpriteFrames,SpriteFrame_gcover_22-SpriteFrames
	dd SpriteFrame_gcover_23-SpriteFrames,SpriteFrame_gbutterfly_0-SpriteFrames,SpriteFrame_gbutterfly_1-SpriteFrames,SpriteFrame_gbutterfly_2-SpriteFrames
	dd SpriteFrame_gbutterfly_3-SpriteFrames,SpriteFrame_gbutterfly_4-SpriteFrames,SpriteFrame_gbutterfly_5-SpriteFrames,SpriteFrame_gbutterfly_6-SpriteFrames
	dd SpriteFrame_gbutterfly_7-SpriteFrames,SpriteFrame_gbutterfly_8-SpriteFrames,SpriteFrame_gbutterfly_9-SpriteFrames,SpriteFrame_gbutterfly_10-SpriteFrames
	dd SpriteFrame_gbutterfly_11-SpriteFrames,SpriteFrame_gbutterfly_12-SpriteFrames,SpriteFrame_gbutterfly_13-SpriteFrames,SpriteFrame_gbutterfly_14-SpriteFrames
	dd SpriteFrame_gbutterfly_15-SpriteFrames,SpriteFrame_gbutterfly_16-SpriteFrames,SpriteFrame_gbutterfly_17-SpriteFrames,SpriteFrame_gbutterfly_18-SpriteFrames
	dd SpriteFrame_gbutterfly_19-SpriteFrames,SpriteFrame_gbutterfly_20-SpriteFrames,SpriteFrame_gbutterfly_21-SpriteFrames,SpriteFrame_gbutterfly_22-SpriteFrames
	dd SpriteFrame_gbutterfly_23-SpriteFrames,SpriteFrame_gsprawll_0-SpriteFrames,SpriteFrame_gsprawll_1-SpriteFrames,SpriteFrame_gsprawll_2-SpriteFrames
	dd SpriteFrame_gsprawll_3-SpriteFrames,SpriteFrame_gsprawll_4-SpriteFrames,SpriteFrame_gsprawll_5-SpriteFrames,SpriteFrame_gsprawll_6-SpriteFrames
	dd SpriteFrame_gsprawll_7-SpriteFrames,SpriteFrame_gsprawll_8-SpriteFrames,SpriteFrame_gsprawll_9-SpriteFrames,SpriteFrame_gsprawll_10-SpriteFrames
	dd SpriteFrame_gsprawll_11-SpriteFrames,SpriteFrame_gsprawll_12-SpriteFrames,SpriteFrame_gsprawll_13-SpriteFrames,SpriteFrame_gsprawll_14-SpriteFrames
	dd SpriteFrame_gsprawll_15-SpriteFrames,SpriteFrame_gsprawll_16-SpriteFrames,SpriteFrame_gsprawll_17-SpriteFrames,SpriteFrame_gsprawll_18-SpriteFrames
	dd SpriteFrame_gsprawll_19-SpriteFrames,SpriteFrame_gsprawll_20-SpriteFrames,SpriteFrame_gsprawll_21-SpriteFrames,SpriteFrame_gsprawll_22-SpriteFrames
	dd SpriteFrame_gsprawll_23-SpriteFrames,SpriteFrame_gsprawlr_0-SpriteFrames,SpriteFrame_gsprawlr_1-SpriteFrames,SpriteFrame_gsprawlr_2-SpriteFrames
	dd SpriteFrame_gsprawlr_3-SpriteFrames,SpriteFrame_gsprawlr_4-SpriteFrames,SpriteFrame_gsprawlr_5-SpriteFrames,SpriteFrame_gsprawlr_6-SpriteFrames
	dd SpriteFrame_gsprawlr_7-SpriteFrames,SpriteFrame_gsprawlr_8-SpriteFrames,SpriteFrame_gsprawlr_9-SpriteFrames,SpriteFrame_gsprawlr_10-SpriteFrames
	dd SpriteFrame_gsprawlr_11-SpriteFrames,SpriteFrame_gsprawlr_12-SpriteFrames,SpriteFrame_gsprawlr_13-SpriteFrames,SpriteFrame_gsprawlr_14-SpriteFrames
	dd SpriteFrame_gsprawlr_15-SpriteFrames,SpriteFrame_gsprawlr_16-SpriteFrames,SpriteFrame_gsprawlr_17-SpriteFrames,SpriteFrame_gsprawlr_18-SpriteFrames
	dd SpriteFrame_gsprawlr_19-SpriteFrames,SpriteFrame_gsprawlr_20-SpriteFrames,SpriteFrame_gsprawlr_21-SpriteFrames,SpriteFrame_gsprawlr_22-SpriteFrames
	dd SpriteFrame_gsprawlr_23-SpriteFrames,SpriteFrame_pump2_0-SpriteFrames,SpriteFrame_pump2_1-SpriteFrames,SpriteFrame_pump2_2-SpriteFrames
	dd SpriteFrame_pump2_3-SpriteFrames,SpriteFrame_pump2_4-SpriteFrames,SpriteFrame_pump2_5-SpriteFrames,SpriteFrame_pump2_6-SpriteFrames
	dd SpriteFrame_pump2_7-SpriteFrames,SpriteFrame_pump2_8-SpriteFrames,SpriteFrame_pump2_9-SpriteFrames,SpriteFrame_pump2_10-SpriteFrames
	dd SpriteFrame_pump2_11-SpriteFrames,SpriteFrame_pump2_12-SpriteFrames,SpriteFrame_pump2_13-SpriteFrames,SpriteFrame_pump2_14-SpriteFrames
	dd SpriteFrame_pump2_15-SpriteFrames,SpriteFrame_pump2_16-SpriteFrames,SpriteFrame_pump2_17-SpriteFrames,SpriteFrame_pump2_18-SpriteFrames
	dd SpriteFrame_pump2_19-SpriteFrames,SpriteFrame_pump2_20-SpriteFrames,SpriteFrame_pump2_21-SpriteFrames,SpriteFrame_pump2_22-SpriteFrames
	dd SpriteFrame_pump2_23-SpriteFrames,SpriteFrame_pump2_24-SpriteFrames,SpriteFrame_pump2_25-SpriteFrames,SpriteFrame_pump2_26-SpriteFrames
	dd SpriteFrame_pump2_27-SpriteFrames,SpriteFrame_pump2_28-SpriteFrames,SpriteFrame_pump2_29-SpriteFrames,SpriteFrame_pump2_30-SpriteFrames
	dd SpriteFrame_unused_0-SpriteFrames,SpriteFrame_unused_1-SpriteFrames,SpriteFrame_unused_2-SpriteFrames,SpriteFrame_unused_3-SpriteFrames
	dd SpriteFrame_unused_4-SpriteFrames,SpriteFrame_unused_5-SpriteFrames,SpriteFrame_unused_6-SpriteFrames,SpriteFrame_unused_7-SpriteFrames
	dd SpriteFrame_unused_8-SpriteFrames,SpriteFrame_unused_9-SpriteFrames,SpriteFrame_unused_10-SpriteFrames,SpriteFrame_boardfront_0-SpriteFrames
	dd SpriteFrame_boardfront_1-SpriteFrames,SpriteFrame_boardfront_2-SpriteFrames,SpriteFrame_boardfront_3-SpriteFrames,SpriteFrame_boardfront_4-SpriteFrames
	dd SpriteFrame_boardfront_5-SpriteFrames,SpriteFrame_boardfront_6-SpriteFrames,SpriteFrame_boardfront_7-SpriteFrames,SpriteFrame_boardfront_8-SpriteFrames
	dd SpriteFrame_boardfront_9-SpriteFrames,SpriteFrame_boardfront_10-SpriteFrames,SpriteFrame_boardfront_11-SpriteFrames,SpriteFrame_boardfront_12-SpriteFrames
	dd SpriteFrame_boardfront_13-SpriteFrames,SpriteFrame_boardfront_14-SpriteFrames,SpriteFrame_boardfront_15-SpriteFrames,SpriteFrame_boardright_0-SpriteFrames
	dd SpriteFrame_boardright_1-SpriteFrames,SpriteFrame_boardright_2-SpriteFrames,SpriteFrame_boardright_3-SpriteFrames,SpriteFrame_boardright_4-SpriteFrames
	dd SpriteFrame_boardright_5-SpriteFrames,SpriteFrame_boardright_6-SpriteFrames,SpriteFrame_boardright_7-SpriteFrames,SpriteFrame_boardright_8-SpriteFrames
	dd SpriteFrame_boardright_9-SpriteFrames,SpriteFrame_boardright_10-SpriteFrames,SpriteFrame_boardright_11-SpriteFrames,SpriteFrame_boardright_12-SpriteFrames
	dd SpriteFrame_boardright_13-SpriteFrames,SpriteFrame_boardright_14-SpriteFrames,SpriteFrame_boardright_15-SpriteFrames,SpriteFrame_boardback_0-SpriteFrames
	dd SpriteFrame_boardback_1-SpriteFrames,SpriteFrame_boardback_2-SpriteFrames,SpriteFrame_boardback_3-SpriteFrames,SpriteFrame_boardback_4-SpriteFrames
	dd SpriteFrame_boardback_5-SpriteFrames,SpriteFrame_boardback_6-SpriteFrames,SpriteFrame_boardback_7-SpriteFrames,SpriteFrame_boardback_8-SpriteFrames
	dd SpriteFrame_boardback_9-SpriteFrames,SpriteFrame_boardback_10-SpriteFrames,SpriteFrame_boardback_11-SpriteFrames,SpriteFrame_boardback_12-SpriteFrames
	dd SpriteFrame_boardback_13-SpriteFrames,SpriteFrame_boardback_14-SpriteFrames,SpriteFrame_boardback_15-SpriteFrames,SpriteFrame_boardleft_0-SpriteFrames
	dd SpriteFrame_boardleft_1-SpriteFrames,SpriteFrame_boardleft_2-SpriteFrames,SpriteFrame_boardleft_3-SpriteFrames,SpriteFrame_boardleft_4-SpriteFrames
	dd SpriteFrame_boardleft_5-SpriteFrames,SpriteFrame_boardleft_6-SpriteFrames,SpriteFrame_boardleft_7-SpriteFrames,SpriteFrame_boardleft_8-SpriteFrames
	dd SpriteFrame_boardleft_9-SpriteFrames,SpriteFrame_boardleft_10-SpriteFrames,SpriteFrame_boardleft_11-SpriteFrames,SpriteFrame_boardleft_12-SpriteFrames
	dd SpriteFrame_boardleft_13-SpriteFrames,SpriteFrame_boardleft_14-SpriteFrames,SpriteFrame_boardleft_15-SpriteFrames,SpriteFrame_benchcheck_0-SpriteFrames
	dd SpriteFrame_benchcheck_1-SpriteFrames,SpriteFrame_benchcheck_2-SpriteFrames,SpriteFrame_benchcheck_3-SpriteFrames,SpriteFrame_benchcheck_4-SpriteFrames
	dd SpriteFrame_benchcheck_5-SpriteFrames,SpriteFrame_benchcheck_6-SpriteFrames,SpriteFrame_benchcheck_7-SpriteFrames,SpriteFrame_benchcheck_8-SpriteFrames
	dd SpriteFrame_benchcheck_9-SpriteFrames,SpriteFrame_benchcheck_10-SpriteFrames,SpriteFrame_benchcheck_11-SpriteFrames,SpriteFrame_benchcheck_12-SpriteFrames
	dd SpriteFrame_benchcheck_13-SpriteFrames,SpriteFrame_benchcheck_14-SpriteFrames,SpriteFrame_benchcheck_15-SpriteFrames,SpriteFrame_benchcheck_16-SpriteFrames
	dd SpriteFrame_benchcheck_17-SpriteFrames,SpriteFrame_benchcheck_18-SpriteFrames,SpriteFrame_benchcheck_19-SpriteFrames,SpriteFrame_benchcheck_20-SpriteFrames
	dd SpriteFrame_bench_0-SpriteFrames,SpriteFrame_bench_1-SpriteFrames,SpriteFrame_bench_2-SpriteFrames,SpriteFrame_bench_3-SpriteFrames
	dd SpriteFrame_bench_4-SpriteFrames,SpriteFrame_bench_5-SpriteFrames,SpriteFrame_bench_6-SpriteFrames,SpriteFrame_bench_7-SpriteFrames
	dd SpriteFrame_bench_8-SpriteFrames,SpriteFrame_bench_9-SpriteFrames,SpriteFrame_bench_10-SpriteFrames,SpriteFrame_bench_11-SpriteFrames
	dd SpriteFrame_bigfont_0-SpriteFrames,SpriteFrame_bigfont_1-SpriteFrames,SpriteFrame_bigfont_2-SpriteFrames,SpriteFrame_bigfont_3-SpriteFrames
	dd SpriteFrame_bigfont_4-SpriteFrames,SpriteFrame_bigfont_5-SpriteFrames,SpriteFrame_bigfont_6-SpriteFrames,SpriteFrame_bigfont_7-SpriteFrames
	dd SpriteFrame_bigfont_8-SpriteFrames,SpriteFrame_bigfont_9-SpriteFrames,SpriteFrame_bigfont_10-SpriteFrames,SpriteFrame_bigfont_11-SpriteFrames
	dd SpriteFrame_bigfont_12-SpriteFrames,SpriteFrame_bigfont_13-SpriteFrames,SpriteFrame_bigfont_14-SpriteFrames,SpriteFrame_bigfont_15-SpriteFrames
	dd SpriteFrame_bigfont_16-SpriteFrames,SpriteFrame_bigfont_17-SpriteFrames,SpriteFrame_bigfont_18-SpriteFrames,SpriteFrame_bigfont_19-SpriteFrames
	dd SpriteFrame_bigfont_20-SpriteFrames,SpriteFrame_bigfont_21-SpriteFrames,SpriteFrame_bigfont_22-SpriteFrames,SpriteFrame_bigfont_23-SpriteFrames
	dd SpriteFrame_bigfont_24-SpriteFrames,SpriteFrame_bigfont_25-SpriteFrames,SpriteFrame_bigfont_26-SpriteFrames,SpriteFrame_bigfont_27-SpriteFrames
	dd SpriteFrame_bigfont_28-SpriteFrames,SpriteFrame_bigfont_29-SpriteFrames,SpriteFrame_bigfont_30-SpriteFrames,SpriteFrame_bigfont_31-SpriteFrames
	dd SpriteFrame_bigfont_32-SpriteFrames,SpriteFrame_bigfont_33-SpriteFrames,SpriteFrame_bigfont_34-SpriteFrames,SpriteFrame_bigfont_35-SpriteFrames
	dd SpriteFrame_bigfont_36-SpriteFrames,SpriteFrame_bigfont_37-SpriteFrames,SpriteFrame_hat_0-SpriteFrames,SpriteFrame_hat_1-SpriteFrames
	dd SpriteFrame_hat_2-SpriteFrames,SpriteFrame_hat_3-SpriteFrames,SpriteFrame_hat_4-SpriteFrames,SpriteFrame_hat_5-SpriteFrames
	dd SpriteFrame_hat_6-SpriteFrames,SpriteFrame_hat_7-SpriteFrames,SpriteFrame_hat_8-SpriteFrames,SpriteFrame_hatshadow_0-SpriteFrames
SpriteFrame_skatewp_0:
	db $03,$80
	dw $0009
	dw -6,7,-30,4
	dw $00A0,$0080
	dw .tiles-SpriteFrame_skatewp_0
	db $02,$E4,$00,$00
	dw -6,-30,$0800 : db $FF
	dw -6,-14,$0802 : db $FF
	dw -2,2,$0804 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames82.bin":43..331

SpriteFrame_skatewp_1:
	db $05,$80
	dw $000B
	dw -9,9,-29,5
	dw $00C0,$00A0
	dw .tiles-SpriteFrame_skatewp_1
	db $01,$E5,$00,$00
	dw -3,-29,$0800 : db $FF
	dw -9,-13,$0802 : db $FF
	dw 7,-5,$0804 : db $00
	dw -8,3,$0805 : db $00
	dw 0,3,$0814 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames82.bin":388..740
SpriteFrame_skatewp_2:
	db $02,$80
	dw $0008
	dw -5,6,-27,4
	dw $0080,$0080
	dw .tiles-SpriteFrame_skatewp_2
	db $02,$E7,$00,$00
	dw -5,-27,$0800 : db $FF
	dw -5,-11,$0802 : db $FF
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames82.bin":776..1032
SpriteFrame_skatewp_3:
	db $02,$80
	dw $0008
	dw -6,9,-26,5
	dw $0080,$0080
	dw .tiles-SpriteFrame_skatewp_3
	db $00,$E7,$00,$00
	dw -6,-26,$0800 : db $FF
	dw -4,-10,$0802 : db $FF
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames82.bin":1068..1324
SpriteFrame_skatewp_4:
	db $02,$80
	dw $0008
	dw -5,8,-26,4
	dw $0080,$0080
	dw .tiles-SpriteFrame_skatewp_4
	db $02,$E7,$00,$00
	dw -4,-26,$0800 : db $FF
	dw -5,-10,$0802 : db $FF
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames82.bin":1360..1616
SpriteFrame_skatewp_5:
	db $03,$80
	dw $000C
	dw -7,18,-21,7
	dw $00C0,$00C0
	dw .tiles-SpriteFrame_skatewp_5
	db $11,$FA,$00,$00
	dw -7,-21,$0800 : db $FF
	dw -7,-5,$0802 : db $FF
	dw 9,-10,$0804 : db $FF
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames82.bin":1659..2043
SpriteFrame_skatewp_6:
	db $05,$80
	dw $000E
	dw -10,19,-25,3
	dw $0100,$00C0
	dw .tiles-SpriteFrame_skatewp_6
	db $0F,$F5,$00,$00
	dw -5,-25,$0800 : db $FF
	dw -10,-9,$0802 : db $FF
	dw 6,-9,$0804 : db $FF
	dw 11,-17,$0806 : db $00
	dw 19,-17,$0807 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames82.bin":2100..2548
SpriteFrame_skatewp_7:
	db $03,$80
	dw $0009
	dw -6,17,-26,2
	dw $00A0,$0080
	dw .tiles-SpriteFrame_skatewp_7
	db $0D,$F6,$00,$00
	dw -6,-13,$0800 : db $FF
	dw -2,-29,$0802 : db $FF
	dw 10,-13,$0804 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames82.bin":2591..2879
SpriteFrame_skatewp_8:
	db $03,$80
	dw $000C
	dw -8,16,-25,4
	dw $00C0,$00C0
	dw .tiles-SpriteFrame_skatewp_8
	db $10,$F8,$00,$00
	dw -8,-25,$0800 : db $FF
	dw -8,-9,$0802 : db $FF
	dw 8,-12,$0804 : db $FF
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames82.bin":2922..3306
SpriteFrame_skatewp_9:
	db $03,$80
	dw $0009
	dw -6,15,-24,4
	dw $00A0,$0080
	dw .tiles-SpriteFrame_skatewp_9
	db $10,$F9,$00,$00
	dw -6,-11,$0800 : db $FF
	dw -6,-27,$0802 : db $FF
	dw 10,-11,$0804 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames82.bin":3349..3637
SpriteFrame_skatewp_10:
	db $04,$80
	dw $000A
	dw -2,21,-23,6
	dw $00C0,$0080
	dw .tiles-SpriteFrame_skatewp_10
	db $12,$00,$00,$00
	dw -1,-23,$0800 : db $FF
	dw -2,-7,$0802 : db $FF
	dw 14,-7,$0804 : db $00
	dw 14,1,$0805 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames82.bin":3687..4007
SpriteFrame_skatewp_11:
	db $03,$80
	dw $000C
	dw -5,23,-23,5
	dw $00C0,$00C0
	dw .tiles-SpriteFrame_skatewp_11
	db $14,$03,$00,$00
	dw -1,-23,$0800 : db $FF
	dw -5,-7,$0802 : db $FF
	dw 11,-7,$0804 : db $FF
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames82.bin":4050..4434

SpriteFrame_skatewp_12:
	db $03,$80
	dw $000C
	dw -5,21,-23,6
	dw $00C0,$00C0
	dw .tiles-SpriteFrame_skatewp_12
	db $12,$03,$00,$00
	dw -1,-23,$0800 : db $FF
	dw -5,-7,$0802 : db $FF
	dw 11,-7,$0804 : db $FF
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames82.bin":4477..4861
SpriteFrame_skatewp_13:
	db $04,$80
	dw $000D
	dw -11,22,-25,3
	dw $00E0,$00C0
	dw .tiles-SpriteFrame_skatewp_13
	db $14,$FF,$00,$00
	dw -5,-25,$0800 : db $FF
	dw -11,-9,$0802 : db $FF
	dw 5,-9,$0804 : db $FF
	dw 21,-1,$0806 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames82.bin":4911..5327
SpriteFrame_skatewp_14:
	db $03,$80
	dw $000C
	dw -9,19,-24,4
	dw $00C0,$00C0
	dw .tiles-SpriteFrame_skatewp_14
	db $10,$03,$00,$00
	dw -5,-24,$0800 : db $FF
	dw -9,-8,$0802 : db $FF
	dw 7,-8,$0804 : db $FF
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames82.bin":5370..5754
SpriteFrame_skatewp_15:
	db $04,$80
	dw $000A
	dw -9,16,-25,6
	dw $00C0,$0080
	dw .tiles-SpriteFrame_skatewp_15
	db $0B,$06,$00,$00
	dw -6,-25,$0800 : db $FF
	dw -9,-9,$0802 : db $FF
	dw 7,-1,$0804 : db $00
	dw 15,-1,$0805 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames82.bin":5804..6124
SpriteFrame_skatewp_16:
	db $03,$80
	dw $0009
	dw -6,16,-23,11
	dw $00A0,$0080
	dw .tiles-SpriteFrame_skatewp_16
	db $0F,$08,$00,$00
	dw -6,-23,$0800 : db $FF
	dw -6,-7,$0802 : db $FF
	dw 10,6,$0804 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames82.bin":6167..6455
SpriteFrame_skatewp_17:
	db $04,$80
	dw $000A
	dw -6,18,-24,9
	dw $00C0,$0080
	dw .tiles-SpriteFrame_skatewp_17
	db $0D,$0A,$00,$00
	dw -6,-24,$0800 : db $FF
	dw -6,-8,$0802 : db $FF
	dw 10,3,$0804 : db $00
	dw 18,3,$0805 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames82.bin":6505..6825
SpriteFrame_skatewp_18:
	db $04,$80
	dw $000D
	dw -12,19,-24,9
	dw $00E0,$00C0
	dw .tiles-SpriteFrame_skatewp_18
	db $11,$06,$00,$00
	dw -6,-24,$0800 : db $FF
	dw -12,-8,$0802 : db $FF
	dw 4,-8,$0804 : db $FF
	dw 13,8,$0806 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames82.bin":6875..7291
SpriteFrame_skatewp_19:
	db $03,$80
	dw $000C
	dw -9,19,-24,9
	dw $00C0,$00C0
	dw .tiles-SpriteFrame_skatewp_19
	db $10,$06,$00,$00
	dw -9,-24,$0800 : db $FF
	dw -9,-8,$0802 : db $FF
	dw 7,-2,$0804 : db $FF
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames82.bin":7334..7718
SpriteFrame_skatewp_20:
	db $03,$80
	dw $0009
	dw -7,7,-23,16
	dw $00A0,$0080
	dw .tiles-SpriteFrame_skatewp_20
	db $FE,$0D,$00,$00
	dw -6,-23,$0800 : db $FF
	dw -7,-7,$0802 : db $FF
	dw 0,9,$0804 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames82.bin":7761..8049
SpriteFrame_skatewp_21:
	db $05,$80
	dw $000B
	dw -7,9,-23,18
	dw $00C0,$00A0
	dw .tiles-SpriteFrame_skatewp_21
	db $01,$0E,$00,$00
	dw -7,-23,$0800 : db $FF
	dw -7,-7,$0802 : db $FF
	dw 9,-7,$0804 : db $00
	dw -1,9,$0805 : db $00
	dw -1,17,$0814 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames82.bin":8106..8458

SpriteFrame_skatewp_22:
	db $04,$80
	dw $000A
	dw -7,6,-23,17
	dw $00C0,$0080
	dw .tiles-SpriteFrame_skatewp_22
	db $FF,$0E,$00,$00
	dw -7,-23,$0800 : db $FF
	dw -7,-7,$0802 : db $FF
	dw 0,9,$0804 : db $00
	dw 0,17,$0805 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames82.bin":8508..8828
SpriteFrame_skatewp_23:
	db $04,$80
	dw $000A
	dw -8,7,-24,19
	dw $00C0,$0080
	dw .tiles-SpriteFrame_skatewp_23
	db $04,$0E,$00,$00
	dw -6,-24,$0800 : db $FF
	dw -8,-8,$0802 : db $FF
	dw 0,8,$0804 : db $00
	dw 0,16,$0805 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames82.bin":8878..9198
SpriteFrame_skatewp_24:
	db $03,$80
	dw $0009
	dw -6,5,-23,16
	dw $00A0,$0080
	dw .tiles-SpriteFrame_skatewp_24
	db $00,$0E,$00,$00
	dw -6,-23,$0800 : db $FF
	dw -5,-7,$0802 : db $FF
	dw -3,9,$0804 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames82.bin":9241..9529
SpriteFrame_skatewp_25:
	db $03,$80
	dw $0009
	dw -12,8,-24,8
	dw $00A0,$0080
	dw .tiles-SpriteFrame_skatewp_25
	db $F5,$03,$00,$00
	dw -7,-24,$0800 : db $FF
	dw -7,-8,$0802 : db $FF
	dw -15,4,$0804 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames82.bin":9572..9860
SpriteFrame_skatewp_26:
	db $03,$80
	dw $000C
	dw -14,14,-22,9
	dw $00C0,$00C0
	dw .tiles-SpriteFrame_skatewp_26
	db $F3,$05,$00,$00
	dw -5,-22,$0800 : db $FF
	dw -14,-6,$0802 : db $FF
	dw 2,-6,$0804 : db $FF
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames82.bin":9903..10287
SpriteFrame_skatewp_27:
	db $04,$80
	dw $000A
	dw -12,11,-24,9
	dw $00C0,$0080
	dw .tiles-SpriteFrame_skatewp_27
	db $F5,$06,$00,$00
	dw -4,-24,$0800 : db $FF
	dw -4,-8,$0802 : db $FF
	dw -12,0,$0804 : db $00
	dw -12,8,$0805 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames82.bin":10337..10657
SpriteFrame_skatewp_28:
	db $03,$80
	dw $000C
	dw -14,10,-23,9
	dw $00C0,$00C0
	dw .tiles-SpriteFrame_skatewp_28
	db $F3,$04,$00,$00
	dw -5,-23,$0800 : db $FF
	dw -5,-7,$0802 : db $FF
	dw -21,-2,$0804 : db $FF
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames82.bin":10700..11084
SpriteFrame_skatewp_29:
	db $04,$80
	dw $000A
	dw -13,9,-23,8
	dw $00C0,$0080
	dw .tiles-SpriteFrame_skatewp_29
	db $F7,$08,$00,$00
	dw -4,-23,$0800 : db $FF
	dw -13,-7,$0802 : db $FF
	dw 3,-7,$0804 : db $00
	dw 3,1,$0805 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames82.bin":11134..11454
SpriteFrame_skatewp_30:
	db $04,$80
	dw $000A
	dw -16,6,-23,8
	dw $00C0,$0080
	dw .tiles-SpriteFrame_skatewp_30
	db $F2,$04,$00,$00
	dw -8,-23,$0800 : db $FF
	dw -16,-7,$0802 : db $FF
	dw 0,-7,$0804 : db $00
	dw 0,1,$0805 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames82.bin":11504..11824
SpriteFrame_skatewp_31:
	db $03,$80
	dw $000C
	dw -20,11,-26,4
	dw $00C0,$00C0
	dw .tiles-SpriteFrame_skatewp_31
	db $EF,$02,$00,$00
	dw -7,-26,$0800 : db $FF
	dw -20,-10,$0802 : db $FF
	dw -4,-10,$0804 : db $FF
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames82.bin":11867..12251
SpriteFrame_skatewp_32:
	db $03,$80
	dw $000C
	dw -17,7,-25,4
	dw $00C0,$00C0
	dw .tiles-SpriteFrame_skatewp_32
	db $F0,$03,$00,$00
	dw -7,-25,$0800 : db $FF
	dw -17,-9,$0802 : db $FF
	dw -1,-9,$0804 : db $FF
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames82.bin":12294..12678

SpriteFrame_skatewp_33:
	db $03,$80
	dw $000C
	dw -20,11,-25,3
	dw $00C0,$00C0
	dw .tiles-SpriteFrame_skatewp_33
	db $EE,$FE,$00,$00
	dw -7,-25,$0800 : db $FF
	dw -20,-9,$0802 : db $FF
	dw -4,-9,$0804 : db $FF
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames82.bin":12721..13105
SpriteFrame_skatewp_34:
	db $04,$80
	dw $000A
	dw -18,5,-25,5
	dw $00C0,$0080
	dw .tiles-SpriteFrame_skatewp_34
	db $F0,$FE,$00,$00
	dw -7,-25,$0800 : db $FF
	dw -18,-9,$0802 : db $FF
	dw -2,-9,$0804 : db $00
	dw -2,-1,$0805 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames82.bin":13155..13475
SpriteFrame_skatewp_35:
	db $04,$80
	dw $000A
	dw -16,6,-25,4
	dw $00C0,$0080
	dw .tiles-SpriteFrame_skatewp_35
	db $F2,$FB,$00,$00
	dw -7,-25,$0800 : db $FF
	dw -16,-9,$0802 : db $FF
	dw 0,-9,$0804 : db $00
	dw 0,-1,$0805 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames82.bin":13525..13845
SpriteFrame_skatewp_36:
	db $04,$80
	dw $000A
	dw -15,8,-26,4
	dw $00C0,$0080
	dw .tiles-SpriteFrame_skatewp_36
	db $F5,$F7,$00,$00
	dw -15,-11,$0800 : db $FF
	dw -4,-27,$0802 : db $FF
	dw 1,-11,$0804 : db $00
	dw 1,-3,$0805 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames82.bin":13895..14215
SpriteFrame_skatewp_37:
	db $03,$80
	dw $000C
	dw -15,9,-26,3
	dw $00C0,$00C0
	dw .tiles-SpriteFrame_skatewp_37
	db $F2,$FA,$00,$00
	dw -15,-12,$0800 : db $FF
	dw 1,-12,$0802 : db $FF
	dw -4,-28,$0804 : db $FF
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames82.bin":14258..14642
SpriteFrame_skatewp_38:
	db $03,$80
	dw $000C
	dw -15,16,-26,0
	dw $00C0,$00C0
	dw .tiles-SpriteFrame_skatewp_38
	db $F6,$F5,$00,$00
	dw -15,-15,$0800 : db $FF
	dw 1,-15,$0802 : db $FF
	dw -3,-31,$0804 : db $FF
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames82.bin":14685..15069
SpriteFrame_skatewp_39:
	db $03,$80
	dw $000C
	dw -16,12,-26,3
	dw $00C0,$00C0
	dw .tiles-SpriteFrame_skatewp_39
	db $F1,$F8,$00,$00
	dw -3,-26,$0800 : db $FF
	dw -3,-10,$0802 : db $FF
	dw -19,-14,$0804 : db $FF
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames82.bin":15112..15496
SpriteFrame_skate_0:
	db $04,$80
	dw $000A
	dw -10,7,-26,4
	dw $00C0,$0080
	dw .tiles-SpriteFrame_skate_0
	db $F8,$FD,$00,$00
	dw -10,-26,$0800 : db $FF
	dw -8,-10,$0802 : db $FF
	dw 6,-26,$0804 : db $00
	dw 6,-18,$0805 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames82.bin":15546..15866
SpriteFrame_skate_1:
	db $04,$80
	dw $000A
	dw -12,8,-24,6
	dw $00C0,$0080
	dw .tiles-SpriteFrame_skate_1
	db $F6,$FD,$00,$00
	dw -12,-24,$0800 : db $FF
	dw -9,-8,$0802 : db $FF
	dw 4,-24,$0804 : db $00
	dw 4,-16,$0805 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames82.bin":15916..16236
SpriteFrame_skate_2:
	db $04,$80
	dw $000A
	dw -13,7,-25,4
	dw $00C0,$0080
	dw .tiles-SpriteFrame_skate_2
	db $F6,$FF,$00,$00
	dw -13,-25,$0800 : db $FF
	dw -4,-9,$0802 : db $FF
	dw 3,-25,$0804 : db $00
	dw 3,-17,$0805 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames82.bin":16286..16606

SpriteFrame_skate_3:
	db $04,$80
	dw $000A
	dw -14,6,-25,4
	dw $00C0,$0080
	dw .tiles-SpriteFrame_skate_3
	db $F4,$FA,$00,$00
	dw -14,-25,$0800 : db $FF
	dw -7,-9,$0802 : db $FF
	dw 2,-25,$0804 : db $00
	dw 2,-17,$0805 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames82.bin":16656..16976
SpriteFrame_skate_4:
	db $04,$80
	dw $000A
	dw -9,9,-24,3
	dw $00C0,$0080
	dw .tiles-SpriteFrame_skate_4
	db $F9,$FB,$00,$00
	dw -9,-24,$0800 : db $FF
	dw -3,-8,$0802 : db $FF
	dw 7,-24,$0804 : db $00
	dw 7,-16,$0805 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames82.bin":17026..17346
SpriteFrame_skate_5:
	db $02,$80
	dw $0008
	dw -4,9,-23,6
	dw $0080,$0080
	dw .tiles-SpriteFrame_skate_5
	db $FE,$F9,$00,$00
	dw -3,-23,$0800 : db $FF
	dw -4,-7,$0802 : db $FF
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames82.bin":17382..17638
SpriteFrame_skate_6:
	db $02,$80
	dw $0008
	dw -4,11,-23,5
	dw $0080,$0080
	dw .tiles-SpriteFrame_skate_6
	db $02,$FC,$00,$00
	dw 0,-23,$0800 : db $FF
	dw -4,-7,$0802 : db $FF
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames82.bin":17674..17930
SpriteFrame_skate_7:
	db $02,$80
	dw $0008
	dw -5,8,-24,6
	dw $0080,$0080
	dw .tiles-SpriteFrame_skate_7
	db $FF,$FB,$00,$00
	dw -2,-24,$0800 : db $FF
	dw -5,-8,$0802 : db $FF
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames82.bin":17966..18222
SpriteFrame_skate_8:
	db $02,$80
	dw $0008
	dw -5,5,-24,6
	dw $0080,$0080
	dw .tiles-SpriteFrame_skate_8
	db $FC,$F6,$00,$00
	dw -5,-24,$0800 : db $FF
	dw -5,-8,$0802 : db $FF
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames82.bin":18258..18514
SpriteFrame_skate_9:
	db $02,$80
	dw $0008
	dw -2,7,-25,4
	dw $0080,$0080
	dw .tiles-SpriteFrame_skate_9
	db $FE,$F7,$00,$00
	dw -2,-25,$0800 : db $FF
	dw -2,-9,$0802 : db $FF
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames82.bin":18550..18806
SpriteFrame_skate_10:
	db $03,$80
	dw $0009
	dw -5,13,-24,6
	dw $00A0,$0080
	dw .tiles-SpriteFrame_skate_10
	db $0C,$FE,$00,$00
	dw -5,-24,$0800 : db $FF
	dw -4,-8,$0802 : db $FF
	dw 11,-16,$0804 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames82.bin":18849..19137
SpriteFrame_skate_11:
	db $03,$80
	dw $0009
	dw -5,19,-22,7
	dw $00A0,$0080
	dw .tiles-SpriteFrame_skate_11
	db $12,$01,$00,$00
	dw 0,-22,$0800 : db $FF
	dw -5,-6,$0802 : db $FF
	dw 16,-14,$0804 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames82.bin":19180..19468
SpriteFrame_skate_12:
	db $04,$80
	dw $000A
	dw -4,18,-25,5
	dw $00C0,$0080
	dw .tiles-SpriteFrame_skate_12
	db $10,$FD,$00,$00
	dw -4,-25,$0800 : db $FF
	dw -4,-9,$0802 : db $FF
	dw 12,-24,$0804 : db $00
	dw 12,-16,$0805 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames82.bin":19518..19838
SpriteFrame_skate_13:
	db $05,$80
	dw $000B
	dw -7,18,-23,5
	dw $00C0,$00A0
	dw .tiles-SpriteFrame_skate_13
	db $10,$00,$00,$00
	dw -1,-23,$0800 : db $FF
	dw -7,-7,$0802 : db $FF
	dw 15,-15,$0804 : db $00
	dw 9,-7,$0805 : db $00
	dw 9,1,$0814 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames82.bin":19895..20247
SpriteFrame_skate_14:
	db $03,$80
	dw $0009
	dw -7,13,-24,7
	dw $00A0,$0080
	dw .tiles-SpriteFrame_skate_14
	db $0A,$01,$00,$00
	dw -7,-24,$0800 : db $FF
	dw -7,-8,$0802 : db $FF
	dw 9,-10,$0804 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames82.bin":20290..20578
SpriteFrame_skate_15:
	db $03,$80
	dw $0009
	dw -7,14,-22,6
	dw $00A0,$0080
	dw .tiles-SpriteFrame_skate_15
	db $0D,$02,$00,$00
	dw -7,-22,$0800 : db $FF
	dw -7,-6,$0802 : db $FF
	dw 9,-10,$0804 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames82.bin":20621..20909

SpriteFrame_skate_16:
	db $03,$80
	dw $0009
	dw -3,16,-18,9
	dw $00A0,$0080
	dw .tiles-SpriteFrame_skate_16
	db $0E,$08,$00,$00
	dw -2,-6,$0800 : db $FF
	dw -3,-22,$0802 : db $FF
	dw 14,-6,$0804 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames82.bin":20952..21240
SpriteFrame_skate_17:
	db $03,$80
	dw $0009
	dw -3,15,-21,9
	dw $00A0,$0080
	dw .tiles-SpriteFrame_skate_17
	db $0C,$04,$00,$00
	dw -3,-21,$0800 : db $FF
	dw -2,-5,$0802 : db $FF
	dw 13,-13,$0804 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames82.bin":21283..21571
SpriteFrame_skate_18:
	db $03,$80
	dw $000C
	dw -9,16,-20,5
	dw $00C0,$00C0
	dw .tiles-SpriteFrame_skate_18
	db $0E,$02,$00,$00
	dw -9,-10,$0800 : db $FF
	dw 7,-10,$0802 : db $FF
	dw -4,-26,$0804 : db $FF
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames82.bin":21614..21998
SpriteFrame_skate_19:
	db $03,$80
	dw $0009
	dw -7,15,-22,7
	dw $00A0,$0080
	dw .tiles-SpriteFrame_skate_19
	db $0D,$01,$00,$00
	dw -7,-8,$0800 : db $FF
	dw -4,-24,$0802 : db $FF
	dw 9,-8,$0804 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames82.bin":22041..22329
SpriteFrame_skate_20:
	db $03,$80
	dw $0009
	dw -7,12,-22,5
	dw $00A0,$0080
	dw .tiles-SpriteFrame_skate_20
	db $0A,$05,$00,$00
	dw -7,-10,$0800 : db $FF
	dw -7,-26,$0802 : db $FF
	dw 9,-10,$0804 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames82.bin":22372..22660
SpriteFrame_skate_21:
	db $04,$80
	dw $0007
	dw -8,12,-19,4
	dw $0080,$0060
	dw .tiles-SpriteFrame_skate_21
	db $0A,$02,$00,$00
	dw -8,-19,$0800 : db $FF
	dw 8,-11,$0802 : db $00
	dw -7,-3,$0803 : db $00
	dw 1,-3,$0812 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames82.bin":22710..22934
SpriteFrame_skate_22:
	db $03,$80
	dw $0009
	dw -8,12,-21,5
	dw $00A0,$0080
	dw .tiles-SpriteFrame_skate_22
	db $09,$04,$00,$00
	dw -8,-21,$0800 : db $FF
	dw -6,-5,$0802 : db $FF
	dw 8,-13,$0804 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames82.bin":22977..23265
SpriteFrame_skate_23:
	db $03,$80
	dw $0009
	dw -6,14,-18,10
	dw $00A0,$0080
	dw .tiles-SpriteFrame_skate_23
	db $0C,$09,$00,$00
	dw -6,-5,$0800 : db $FF
	dw -4,-21,$0802 : db $FF
	dw 10,-5,$0804 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames82.bin":23308..23596
SpriteFrame_skate_24:
	db $02,$80
	dw $0008
	dw -5,12,-20,6
	dw $0080,$0080
	dw .tiles-SpriteFrame_skate_24
	db $0A,$08,$00,$00
	dw -3,-9,$0800 : db $FF
	dw -5,-25,$0802 : db $FF
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames82.bin":23632..23888
SpriteFrame_skate_25:
	db $02,$80
	dw $0008
	dw -5,6,-21,5
	dw $0080,$0080
	dw .tiles-SpriteFrame_skate_25
	db $01,$08,$00,$00
	dw -5,-21,$0800 : db $FF
	dw -5,-5,$0802 : db $FF
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames82.bin":23924..24180
SpriteFrame_skate_26:
	db $04,$80
	dw $000A
	dw -10,9,-20,7
	dw $00C0,$0080
	dw .tiles-SpriteFrame_skate_26
	db $FF,$07,$00,$00
	dw -9,-20,$0800 : db $FF
	dw -10,-4,$0802 : db $FF
	dw 6,-4,$0804 : db $00
	dw 6,4,$0805 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames82.bin":24230..24550
SpriteFrame_skate_27:
	db $02,$80
	dw $0008
	dw -9,8,-21,6
	dw $0080,$0080
	dw .tiles-SpriteFrame_skate_27
	db $FB,$04,$00,$00
	dw -9,-21,$0800 : db $FF
	dw -6,-5,$0802 : db $FF
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames82.bin":24586..24842

SpriteFrame_skate_28:
	db $02,$80
	dw $0008
	dw -12,4,-19,7
	dw $0080,$0080
	dw .tiles-SpriteFrame_skate_28
	db $F7,$07,$00,$00
	dw -12,-19,$0800 : db $FF
	dw -11,-3,$0802 : db $FF
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames82.bin":24878..25134
SpriteFrame_skate_29:
	db $02,$80
	dw $0008
	dw -9,4,-22,6
	dw $0080,$0080
	dw .tiles-SpriteFrame_skate_29
	db $F9,$05,$00,$00
	dw -8,-22,$0800 : db $FF
	dw -9,-6,$0802 : db $FF
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames82.bin":25170..25426
SpriteFrame_skate_30:
	db $04,$80
	dw $000A
	dw -15,5,-25,5
	dw $00C0,$0080
	dw .tiles-SpriteFrame_skate_30
	db $F4,$06,$00,$00
	dw -9,-25,$0800 : db $FF
	dw -15,-9,$0802 : db $FF
	dw 1,-9,$0804 : db $00
	dw 1,-1,$0805 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames82.bin":25476..25796
SpriteFrame_skate_31:
	db $06,$80
	dw $000C
	dw -16,10,-24,4
	dw $00C0,$00C0
	dw .tiles-SpriteFrame_skate_31
	db $F3,$05,$00,$00
	dw -16,-24,$0800 : db $FF
	dw -7,-8,$0802 : db $FF
	dw 0,-24,$0804 : db $00
	dw 0,-16,$0805 : db $00
	dw 9,-8,$0814 : db $00
	dw 9,0,$0815 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames82.bin":25860..26244
SpriteFrame_skate_32:
	db $04,$80
	dw $000A
	dw -17,6,-23,7
	dw $00C0,$0080
	dw .tiles-SpriteFrame_skate_32
	db $F2,$06,$00,$00
	dw -17,-8,$0800 : db $FF
	dw -8,-24,$0802 : db $FF
	dw -1,-8,$0804 : db $00
	dw -1,0,$0805 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames82.bin":26294..26614
SpriteFrame_skate_33:
	db $05,$80
	dw $000E
	dw -18,10,-23,6
	dw $0100,$00C0
	dw .tiles-SpriteFrame_skate_33
	db $F1,$05,$00,$00
	dw -18,-23,$0800 : db $FF
	dw -15,-7,$0802 : db $FF
	dw 1,-7,$0804 : db $FF
	dw -2,-23,$0806 : db $00
	dw -2,-15,$0807 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames82.bin":26671..27119
SpriteFrame_skate_34:
	db $03,$80
	dw $0009
	dw -16,5,-24,6
	dw $00A0,$0080
	dw .tiles-SpriteFrame_skate_34
	db $F3,$06,$00,$00
	dw -10,-24,$0800 : db $FF
	dw -10,-8,$0802 : db $FF
	dw -18,-10,$0804 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames82.bin":27162..27450
SpriteFrame_skate_35:
	db $04,$80
	dw $000A
	dw -15,6,-25,3
	dw $00C0,$0080
	dw .tiles-SpriteFrame_skate_35
	db $F4,$03,$00,$00
	dw -15,-12,$0800 : db $FF
	dw -5,-28,$0802 : db $FF
	dw 1,-12,$0804 : db $00
	dw 1,-4,$0805 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames82.bin":27500..27820
SpriteFrame_skate_36:
	db $03,$80
	dw $0009
	dw -15,6,-24,6
	dw $00A0,$0080
	dw .tiles-SpriteFrame_skate_36
	db $F5,$06,$00,$00
	dw -9,-24,$0800 : db $FF
	dw -9,-8,$0802 : db $FF
	dw -17,-11,$0804 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames82.bin":27863..28151
SpriteFrame_skate_37:
	db $04,$80
	dw $000A
	dw -16,4,-24,3
	dw $00C0,$0080
	dw .tiles-SpriteFrame_skate_37
	db $F3,$03,$00,$00
	dw -16,-12,$0800 : db $FF
	dw -7,-28,$0802 : db $FF
	dw 0,-12,$0804 : db $00
	dw 0,-4,$0805 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames82.bin":28201..28521
