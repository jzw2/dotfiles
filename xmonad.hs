import XMonad

import XMonad.Util.EZConfig
import XMonad.Util.Ungrab


import XMonad.Layout.ThreeColumns
import XMonad.Layout.Magnifier


import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.DynamicLog
-- import XMonad.Hooks.StatusBar
-- import XMonad.Hooks.StatusBar.PP


import XMonad.Hooks.ManageDocks
import XMonad.Layout.Spacing


import qualified XMonad.StackSet as W

centerlaunch = spawn "exec ~/bin/eww open-many blur_full weather profile quote search_full incognito-icon vpn-icon home_dir screenshot power_full reboot_full lock_full logout_full suspend_full"
sidebarlaunch = spawn "exec ~/bin/eww open-many weather_side time_side smol_calendar player_side sys_side sliders_side"
ewwclose = spawn "exec ~/bin/eww close-all"

myXmobarPP :: PP
myXmobarPP = def
     { ppSep             = magenta " • "
     , ppTitleSanitize   = xmobarStrip
     , ppHidden          = white . wrap " " ""
     , ppHiddenNoWindows = lowWhite . wrap " " ""
     , ppUrgent          = red . wrap (yellow "!") (yellow "!")
     , ppOrder           = \[ws, l, _, wins] -> [ws, l, wins]
     }
  where
     formatFocused   = wrap (white    "[") (white    "]") . magenta . ppWindow
     formatUnfocused = wrap (lowWhite "[") (lowWhite "]") . blue    . ppWindow

     -- | Windows should have *some* title, which should not not exceed a
     -- sane length.
     ppWindow :: String -> String
     ppWindow = xmobarRaw . (\w -> if null w then "untitled" else w) . shorten 30

     blue, lowWhite, magenta, red, white, yellow :: String -> String
     magenta  = xmobarColor "#ff79c6" ""
     blue     = xmobarColor "#bd93f9" ""
     white    = xmobarColor "#f8f8f2" ""
     yellow   = xmobarColor "#f1fa8c" ""
     red      = xmobarColor "#ff5555" ""
     lowWhite = xmobarColor "#bbbbbb" ""

main :: IO ()
-- main = xmonad . ewmh =<< statusBar "xmobar" (myXmobarPP) toggleStrutsKey myConfig
--   where
--     toggleStrutsKey :: XConfig Layout -> (KeyMask, KeySym)
--     toggleStrutsKey XConfig{modMask = m} = (m, xK_b)

-- main = xmonad =<< (xmobar $ docks $ ewmh $ myConfig)
main = xmonad $ (docks $ ewmh $ myConfig)

myConfig = def
     { borderWidth = 2
     , terminal = "alacritty"
     , layoutHook = myLayout
     , startupHook = do
         --spawn "ibus-daemon"
         --spawn "picom -f"
         spawn "dunst"
         --spawn "exec ~/bin/eww daemon"
     --, logHook = dynamicLogString def >>= xmonadPropLog
     }
     `additionalKeysP`
     [ ("M-S-z", spawn "xscreensaver-command -lock")
     , ("M-S-=", unGrab *> spawn "scrot -s")
     , ("M-]", spawn "rofi -show drun")
     , ("C-M-<Return>", spawn "rofi -show run")
     , ("M4-<Space>", spawn "rofi -show drun")

     , ("<XF86AudioRaiseVolume>", spawn "pactl set-sink-volume @DEFAULT_SINK@ +5%")
     , ("<XF86AudioLowerVolume>", spawn "pactl set-sink-volume @DEFAULT_SINK@ -5%")
     , ("<XF86AudioMute>", spawn "pactl set-sink-mute @DEFAULT_SINK@ toggle")

     , ("<XF86AudioPrev>", spawn "playerctl previous")
     , ("<XF86AudioPlay>", spawn "playerctl play-pause")
     , ("<XF86AudioNext>", spawn "playerctl next")

     , ("<XF86Search>", spawn "rofi -show drun")

     , ("M4-1", incWindowSpacing 10)
     , ("M4-2", decWindowSpacing 10)
     , ("M4-3", incScreenSpacing 10)
     , ("M4-4", decScreenSpacing 10)
     , ("M4-5", toggleScreenSpacingEnabled)
     , ("M4-<Backspace>", kill)
     , ("M-<F4>", kill)

     , ("C-M4-1", centerlaunch)
     , ("C-M4-2", sidebarlaunch)
     , ("C-M4-3", ewwclose)
     , ("C-M4-4", spawn "exec ~/bin/bartoggle")
     , ("C-M4-5", spawn "exec ~/bin/inhibit_activate")
     , ("C-M4-6", spawn "exec ~/bin/inhibit_deactivate")
     ]
     `additionalMouseBindings`
     [
       ((mod4Mask, button1), (\w -> focus w >> windows W.swapMaster))
     ,((mod4Mask, button2), (killWindow))
     , ((mod4Mask, button3), (windows . W.sink))
     ,((mod4Mask, button4), (const $ sendMessage Expand))
     , ((mod4Mask, button5), (const $ sendMessage Shrink))
     ]


myLayout = avoidStruts $ spacingRaw True (Border 10 10 10 10) True (Border 10 10 10 10) True $ tiled ||| Mirror tiled ||| Full ||| threeCol
  where
    threeCol = magnifiercz' 1.3 $ ThreeColMid nmaster delta ratio
    tiled = Tall nmaster delta ratio
    nmaster = 1
    ratio = 1 /2
    delta = 3 / 100
