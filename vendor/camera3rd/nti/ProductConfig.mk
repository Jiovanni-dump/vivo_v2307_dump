#--------------------------------------------------------------
# algo : zoom
ALGO_ZOOM_LIB_COMPLIE                      := 1
ALGO_ZOOM_DW_SUPPORT                       := 1
ALGO_ZOOM_NOW_SUPPORT                      := 0
ALGO_ZOOM_EX_SUPPORT                       := 0
ALGO_ZOOM_VIVO_SUPPORT                     := 0


#-----------------------------------------------------------
# algo : remosaic
# Rk SamsungJN1 Vivo Samsung3p9 SamsungGM2
REMOSAIC_BACK_ALGONAME                     := 0
ALGO_REMOSAIC_RK_LIB_COMPLIE               := 0
ALGO_REMOSAIC_RK_CPU0_DSP1                 := 0
REMOSAIC_FRONT_ALGONAME                    := Vivo

#--------------------------------------------------------------
# algo : video/preview singleblur
ALGO_VIDEO_SINGLEBLUR_LIB_COMPLIE          := 1


#--------------------------------------------------------------
# algo : singleblur
ALGO_SINGLEBLUR_LIB_COMPLIE                := 1

#--------------------------------------------------------------
# algo : nightportrait
ALGO_NIGHTPORTRAIT_LIB_COMPLIE             := 0

#--------------------------------------------------------------
# algo : portraitstyle
ALGO_PORTRAITSTYLE_LIB_COMPLIE             := 1


#--------------------------------------------------------------
#algo: portraitlight
ALGO_PORTRAITLIGHT_LIB_COMPLIE             := 1

#--------------------------------------------------------------
# algo : relight
ALGO_RELIGHT_LIB_COMPLIE                   := 0
ALGO_VIVORELIGHT_LIB_COMPLIE               := 1

#--------------------------------------------------------------
# algo : supserns
ALGO_SUPERNS_LIB_COMPLIE                   := 0
ALGO_SUPERNS_LIB_COMPLIE_FRONT             := 0

#--------------------------------------------------------------
# algo : supsernsNR
ALGO_SUPERNSNR_LIB_COMPLIE                 := 0
# super night frame 7+3 is 1, 7+5+1+1+1+1 is 0.
ALGO_NEW_SUPERNS_PROCESS                   := 0
#-----------------------------------------------------------
# algo : ainr
ALGO_AINR_LIB_COMPLIE                      := 0
#--------------------------------------------------------------
# algo : rawllhdr
ALGO_RAWLLHDR_LIB_COMPLIE                  := 0
ALGO_RAWLLHDR_SUPERNS_DEPART               := 0
ALGO_RAWLLHDR_USE_RAWNR_1ADD1              := 0
ALGO_RAWLLHDR_USE_RAWNR_RK               := 0

#-----------------------------------------------------------
# algo : sueprmoon
ALGO_SUPERMOON_LIB_COMPLIE                 := 1
ALGO_SUPERMOON_LIB_VERSION_CONTROL         := 2

#-----------------------------------------------------------
# algo : super star
ALGO_SUPERSTAR_LIB_COMPLIE                 := 1
ALGO_SUPERSTAR_LIB_VERSION_CONTROL         := 1

#--------------------------------------------------------------
# algo : preview detect
ALGO_PREVIEW_DETECT_LIB_COMPLIE            := 1

#--------------------------------------------------------------
# algo : night
ALGO_NIGHT_LIB_COMPLIE                     := 1


#--------------------------------------------------------------
# algo : lut
ALGO_LUT_LIB_COMPLIE                       := 1


#--------------------------------------------------------------
# algo : hdr
ALGO_HDR_LIB_COMPLIE                       := 1

#-----------------------------------------------------------
# algo : chromanr
ALGO_CHROMANR_LIB_COMPLIE                  := 1

#--------------------------------------------------------------
# algo : motion denoise
ALGO_MOTION_DENOISE_LIB_COMPLIE                := 0
ALGO_MOTION_DENOISE_FRAME_BY_FRAME_LIB_COMPLIE := 0
ALGO_MOTION_DENOISE_VERSION_CONTROL            := 0
ALGO_MOTION_DENOISE_ONLY_SPORTMODE             := 0

#-----------------------------------------------------------
# algo : dualbokeh preview
ALGO_DUALBOKEH_PREVIEW_LIB_COMPLIE         := 1
ALGO_DUALBOKEH_PREVIEW_VIVO_SUPPORT        := 1

#--------------------------------------------------------------
# algo : dualbokeh shot
ALGO_DUALBOKEH_LIB_COMPLIE                 := 1
ALGO_DUALBOKEH_VIVO_SUPPORT                := 1
ALGO_DUALBOKEH_VIVO_CUP_MODE               := 1


#--------------------------------------------------------------
# algo : distort
ALGO_DISTORTION_LIB_COMPLIE                := 1
ALGO_DISTORTION_ALTEK_VERSION_CONTROL      := 0
ALGO_DISTORTION_VIVO_SUPPORT               := 1



#--------------------------------------------------------------
# algo : beautybody
ALGO_BEAUTYBODY_LIB_COMPLIE                := 0


#--------------------------------------------------------------
# algo : beauty
ALGO_BEAUTY_LIB_COMPLIE                    := 1
ALGO_BEAUTY_VIVO_VERSION_CONTROL           := 4

#-----------------------------------------------------------
# algo : outline
ALGO_OUTLINE_LIB_COMPLIE             := 1
ALGO_OUTLINE_USE_TRUESIGHT           := 0
#--------------------------------------------------------------
# algo : double exposure
ALGO_DOUBLE_EXPO_LIB_COMPLIE                 := 1

#-----------------------------------------------------------
# pipeline shot
USE_VAS_PIPELINE                           := 0
SHOT_USE_VAS_PIPELINE                      := 0

ALGO_COLORFRINGEREDUCTION_LIB_COMPLIE      := 0

#-----------------------------------------------------------
# algo : sat
ALGO_SAT_LIB_COMPLIE                       := 1
ALGO_SAT_VENDOR_VIVO_SUPPORT               := 1
ALGO_FUSION_VENDOR_VIVO_SUPPORT            := 0
ALGO_SAT_VENDOR_FACEPP_SUPPORT             := 0
ALGO_FUSION_VENDOR_FACEPP_SUPPORT          := 0

#-----------------------------------------------------------
# algo : aidetect
ALGO_PREVIEW_AIDETECT_LIB_COMPLIE          := 1


#-----------------------------------------------------------
# algo : palm detect
ALGO_PALM_DETECT_LIB_COMPLIE                := 1
ALGO_PALMDETECT_VENDOR_THIRDPARTY_SUPPORT  	:= 0
ALGO_PALMDETECT_VENDOR_VIVO_SUPPORT       	:= 1
ALGO_PALMDETECT_VENDOR_VIVO_CPUVERSION  	:= 1
ALGO_PALMDETECT_VENDOR_VIVO_GPUVERSION      := 0


#--------------------------------------------------------------
# algo : engine distor
ALGO_ENGINE_DISTORTION_LIB_COMPLIE         := 0
ALGO_DISTORTION_ALTEK_VERSION_CONTROL      := 0


#-----------------------------------------------------------
# algo : engine dualbokeh
ALGO_ENGINE_DUALBOKEH_CALIB_LIB_COMPLIE        := 1
ALGO_ENGINE_DUALBOKEH_CALIB_VIVO_SUPPORT       := 1


#--------------------------------------------------------------
# algo : deflicker
ALGO_DEFLICKER_LIB_COMPLIE                 := 0


#-----------------------------------------------------------
# algo : eye detect
ALGO_EYE_DETECT_LIB_COMPLIE                := 1


#-----------------------------------------------------------
# algo : product num
ALGO_CAMERA3RD_PRODUCT_NUM                   := 0x2326F

#-----------------------------------------------------------
# algo : fd detect algorithm
ALGO_THIRD_PART_ALOG_FD_ALGORITHM_LIB_COMPLIE            :=1
ALGO_VIVO_FD_ALGORITHM_LIB_COMPLIE                       :=1

#-----------------------------------------------------------
# algo : chromanr
ALGO_CHROMANR_LIB_COMPLIE             := 1

#--------------------------------------------------------------
# algo : lightstream
ALGO_LIGHTSTREAM_LIB_COMPLIE               := 0

#--------------------------------------------------------------
# algo : document
ALGO_DOCUMENT_DETECT_LIB_COMPLIE                 := 1

#-----------------------------------------------------------
# algo: third party rawhdr
ALGO_THIRD_PARTY_RAWHDR_LIB_COMPLIE           := 1

#-----------------------------------------------------------
# video shot
ALGO_VIDEO_COPYIMG                         := 1

#-----------------------------------------------------------
#algo : old iso calculation
ALGO_OLD_ISO_CALCULATION_SUPPORT := 1

#-----------------------------------------------------------
#algo : lot detect
ALGO_LOT_DETECT_LIB_COMPLIE := 0

#-----------------------------------------------------------
#algo : demosaic
ALGO_SOFTBRP_LIB_COMPLIE := 0

#-----------------------------------------------------------
#algo : color temperature lut
ALGO_COLOR_TEMPERATURE_SUPPORT := 1


#-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -
# project algo config date, compare with algo overdue end date
# config date > date today or config date < 2021-01-01, not reasonable,
# project compile abort.
# when overdue end date < project algo config date, algo not supported,
# project compile abort.
ALGO_PROJECT_CONFIG_DATE_COMPLIE             := 2023-07-21
