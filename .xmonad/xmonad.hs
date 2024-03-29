----------------------------------------------------------------------
-- Imports
----------------------------------------------------------------------
-- Xmonad
import XMonad
import XMonad.Config.Desktop
import Data.Monoid
import Data.List
import qualified XMonad.StackSet as W

-- Hooks
import XMonad.Hooks.DynamicLog (dynamicLogWithPP, wrap, pad, xmobarPP, xmobarColor, shorten, PP(..))
import XMonad.Hooks.InsertPosition
import XMonad.Hooks.ManageDocks 
import XMonad.Hooks.SetWMName
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageHelpers

-- Utils
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeysP)
import XMonad.Util.SpawnOnce
import XMonad.Util.NamedScratchpad

-- Actions
import XMonad.Actions.CopyWindow (kill1, copy)
import XMonad.Actions.WithAll (sinkAll, killAll)
import XMonad.Actions.CycleWS
import XMonad.Actions.GridSelect

-- Prompt
import XMonad.Prompt
import XMonad.Prompt.Unicode

-- Layout
import XMonad.Layout.PerWorkspace (onWorkspace) 
import XMonad.Layout.Renamed (renamed, Rename(CutWordsLeft, Replace))
import XMonad.Layout.WorkspaceDir
import XMonad.Layout.Spacing (spacing) 
import XMonad.Layout.NoBorders
import XMonad.Layout.LimitWindows (limitWindows, increaseLimit, decreaseLimit)
import XMonad.Layout.WindowArranger (windowArrange, WindowArrangerMsg(..))
import XMonad.Layout.Reflect (reflectVert, reflectHoriz, REFLECTX(..), REFLECTY(..))
import XMonad.Layout.MultiToggle (mkToggle, single, EOT(EOT), Toggle(..), (??))
import XMonad.Layout.MultiToggle.Instances (StdTransformers(NBFULL, MIRROR, NOBORDERS))
import qualified XMonad.Layout.ToggleLayouts as T (toggleLayouts, ToggleLayout(Toggle))
import XMonad.Layout.Gaps
import XMonad.Layout.Named
import XMonad.Layout.ResizableTile
import XMonad.Layout.ThreeColumns
-- import XMonad.Layout.SimplestFloat
import XMonad.Layout.IndependentScreens (countScreens)

-- System
import System.IO

-- Control
import Control.Monad (liftM2)


----------------------------------------------------------------------
-- Variables
----------------------------------------------------------------------
myFont          = "xft:Ubuntu Mono Nerd Font:regular:pixelsize=12"
myModMask       = mod4Mask  -- Sets modkey to super/windows key
myTerminal      = "$MYTERM" -- Sets default terminal using MYTERM defined in .xprofile
myTextEditor    = "emacsclient -c -n -a ''"     -- Sets default text editor
myBorderWidth   = 2         -- Sets border width for windows
myGaps          = 6
windowCount     = gets $ Just . show . length . W.integrate' . W.stack . W.workspace . W.current . windowset
home            = "/home/loki/"
scripts         = (home ++ ".scripts/")


----------------------------------------------------------------------
-- Main
----------------------------------------------------------------------
main = do
    nScreens <- countScreens
    -- primary display
    xmproc0 <- spawnPipe "xmobar -x 0 -d /home/loki/.config/xmobar/xmobarrc0"
    xmproc1 <- if nScreens > 1
      then spawnPipe "xmobar -x 1 -d /home/loki/.config/xmobar/xmobarrc1"
      else spawnPipe "/dev/null"
      
    xmonad $ ewmh desktopConfig
        { manageHook = manageDocks <+> myManageHook <+> manageHook desktopConfig
        , logHook = dynamicLogWithPP xmobarPP
                        { ppOutput = \x -> hPutStrLn xmproc0 x  >> hPutStrLn xmproc1 x
                        , ppCurrent = xmobarColor "#e69055" "" . wrap "" "" -- Current workspace in xmobar
                        , ppVisible = xmobarColor "#7bc275" ""                -- Visible but not current workspace
                        , ppHidden = xmobarColor "#1f5582" "" . wrap "" ""   -- Hidden workspaces in xmobar
                        , ppHiddenNoWindows = xmobarColor "#484854" ""        -- Hidden workspaces (no windows)
                        , ppTitle = xmobarColor "#bbc2cf" "" . shorten 80     -- Title of active window in xmobar
                        , ppSep =  "<fc=#bbc2cf> : </fc>"                     -- Separators in xmobar
                        , ppUrgent = xmobarColor "#ff665c" "" . wrap "!" "!"  -- Urgent workspace
                        , ppExtras  = [windowCount]                           -- # of windows current workspace
                        , ppOrder  = \(ws:l:t:ex) -> [ws,l]++ex++[t]
                        }

        , modMask = mod4Mask     -- Rebind Mod to the Windows key
        , terminal           = myTerminal
        , layoutHook         = myLayoutHook
        , startupHook        = myStartupHook
        , workspaces         = myWorkspaces
        , borderWidth        = myBorderWidth
        , normalBorderColor  = "#242730"
        , focusedBorderColor = "#e69055"
        } `additionalKeysP` myKeys


----------------------------------------------------------------------
-- Managehooks
----------------------------------------------------------------------
--["1:\xf269", "2:\xf15c", "3:\xf120", "4:\xf25d", "5:\xf07c",
--"6:\xf001", "7:\xf0ac", "8:\xf1dd", "9:\xf1fc", "0:\xf0e0", "ß:\xf11b"]
myManageHook :: Query (Data.Monoid.Endo WindowSet)
--myManageHook = insertPosition Below Newer <+> composeAll
myManageHook = composeAll
     [
       --isDialog                                           --> doF W.swapUp
     -- swapdowns
       className =? "kitty"                               --> doF W.swapDown
     , className =? "urxvtc"                              --> doF W.swapDown
     , className =? "Alacritty"                           --> doF W.swapDown
     -- dedicated workspaces
     , className =? "librewolf"                           --> viewShift "1:\xf269"
     , className =? "LibreWolf"                           --> viewShift "1:\xf269"
     , className =? "Navigator"                           --> viewShift "1:\xf269"
     , className =? "firefox"                             --> viewShift "1:\xf269"
     , className =? "Chromium"                            --> viewShift "1:\xf269"
     , className =? "Emacs"                               --> viewShift "2:\xf15c"
     , className =? "RStudio"                             --> viewShift "4:\xf25d"
     , className =? "Pcmanfm"                             --> viewShift "5:\xf07c"
     , className =? "Doublecmd"                           --> viewShift "5:\xf07c"
     , title =?     "ncmpcpp"                             --> viewShift "6:\xf001"
     , className =? "QGIS3"                               --> viewShift "7:\xf0ac"
     , className =? "TeXstudio"                           --> viewShift "8:\xf1dd"
     , className =? "libreoffice-startcenter"             --> viewShift "8:\xf1dd"
     , className =? "libreoffice-writer"                  --> viewShift "8:\xf1dd"
     , className =? "libreoffice-calc"                    --> viewShift "8:\xf1dd"
     , className =? "libreoffice-impress"                 --> viewShift "8:\xf1dd"
     , className =? "libreoffice"                         --> viewShift "8:\xf1dd"
     , className =? "org.jabref.JabRefMain"               --> viewShift "8:\xf1dd"
     , className =? "Inkscape"                            --> viewShift "9:\xf1fc"
     , className =? "Gimp"                                --> viewShift "9:\xf1fc"
     , className =? "Signal"                              --> viewShift "0:\xf0e0"
     , className =? "TelegramDesktop"                     --> viewShift "0:\xf0e0"
     , className =? "Thunderbird"                         --> viewShift "0:\xf0e0"
     , className =? "qTox"                                --> viewShift "0:\xf0e0"
     , className =? "Steam"                               --> viewShift "ß:\xf11b"
     -- floats
     , title =?      "Auto-Type - KeePassXC"              --> floatkpx
     , (className =? "firefox" <&&> resource =? "Dialog") --> doCenterFloat  -- Float Firefox Dialog
     , className =? "KeePassXC"                           --> doCenterFloat
     , isDialog                                           --> doCenterFloat  -- Float Dialogs
     , title =? "Media viewer"                            --> doCenterFloat
--     , fmap (t `isInfixOf`) title     --> doCenterFloat | t <- titleFloats
--     , fmap (t `isInfixOf`) className --> doCenterFloat | c <- classFloats
     ] <+> namedScratchpadManageHook myScratchPads
  where viewShift = doF . liftM2 (.) W.view W.shift
        floatkpx = doRectFloat $ W.RationalRect 0.33 0.33 0.33 0.33
        titleFloats = ["Copying", "Media viewer", "Select entry type"]
        classFloats = ["KeePassXC", "myCookbook", "Tor Browser", "cloud-drive-ui"]
 


----------------------------------------------------------------------
-- Layouts
----------------------------------------------------------------------
myLayoutHook = avoidStruts $ windowArrange $ smartBorders $
               mkToggle (NBFULL ?? NOBORDERS ?? EOT) $ myDefaultLayout
             where 
                 myDefaultLayout = tall ||| centermaster ||| noBorders monocle -- ||| floats
tall         = renamed [Replace "tall"]     $ limitWindows 12 $ spacing 6 $ ResizableTall 1 (3/100) (1/2) []
centermaster = renamed [Replace "cent"]   $ limitWindows 12 $ spacing 6 $ ThreeColMid 1 (3/100) (1/2)
monocle      = renamed [Replace "mono"]  $ limitWindows 20 $ Full
--floats     = renamed [Replace "floats"]   $ limitWindows 20 $ simplestFloat


----------------------------------------------------------------------
-- Startup
----------------------------------------------------------------------
myStartupHook = do
          spawnOnce "lxsession &"
          spawnOnce "/home/loki/.scripts/autostart.sh &"
          --spawnOnce "stalonetray" 
          setWMName "LG3D"


 
----------------------------------------------------------------------
-- Grid select for going to windows
----------------------------------------------------------------------
myColorizer :: Window -> Bool -> X (String, String)
myColorizer = colorRangeFromClassName
                  (0x29,0x2d,0x3e) -- lowest inactive bg
                  (0x29,0x2d,0x3e) -- highest inactive bg
                  (0xc7,0x92,0xea) -- active bg
                  (0xc0,0xa7,0x9a) -- inactive fg
                  (0x29,0x2d,0x3e) -- active fg
-- gridSelect menu layout
mygridConfig :: p -> GSConfig Window
mygridConfig colorizer = (buildDefaultGSConfig myColorizer)
    { gs_cellheight   = 40
    , gs_cellwidth    = 200
    , gs_cellpadding  = 6
    , gs_originFractX = 0.5
    , gs_originFractY = 0.5
    , gs_font         = "xft:Ubuntu Mono Nerd Font:bold:pixelsize=14"
    }


----------------------------------------------------------------------
-- Key bindings
----------------------------------------------------------------------
myKeys =
        [ 
          -- Xmonad 
          ("M-S-r", spawn "xmonad --recompile")
        , ("M-C-r", spawn "xmonad --restart")
        , ("M-S-n", sendMessage $ Toggle NOBORDERS)
        , ("M-S-<Space>", sendMessage (Toggle NBFULL) >> sendMessage ToggleStruts) -- Toggles noborder/full
        , ("M-i", sendMessage (IncMasterN 1))
        , ("M-d", sendMessage (IncMasterN (-1)))
        -- Window resizing
        , ("M-h", sendMessage Shrink)                   -- Shrink horiz window width
        , ("M-l", sendMessage Expand)                   -- Expand horiz window width
        , ("M-M1-j", sendMessage MirrorShrink)          -- Shrink vert window width
        , ("M-M1-k", sendMessage MirrorExpand)          -- Exoand vert window width

        , ("M-w", spawn "rofi -show window -show-icons -matching fuzzy")  -- goto selected window


        , ("M-S-q", spawn (home ++ ".scripts/dmenu_exit.sh"))
        , ("M-o", nextScreen)
        , ("M-S-o", shiftNextScreen >> nextScreen)
        , ("M-x", swapNextScreen)

        -- Tray
        , ("M-S-t", spawn (scripts ++ "restart_systray.sh stalonetray"))
        
        -- Windows
        , ("M-q", kill1)                           -- Kill the currently focused client
        --, ("M-S-a", killAll)                       -- Kill all the windows on current workspace
        , ("M-S-f", sinkAll)                         -- Push all floating windows back to tile

        -- Terminal
        , ("M-<Return>", spawn myTerminal)

        -- Programs
        , ("M-r", spawn "/home/loki/.scripts/dmenu_recent.sh -i -fn 'Ubuntu Mono Nerd Font:size=11' -nb '#161616' -nf '#D0D0D0' -sf '#444444' -sb '#C45500'")
        , ("M-C-<Return>", spawn "$MYBROWSER")
        , ("M-f", spawn "librewolf")
        , ("M-S-b", spawn (scripts ++ "pabluezswitch.sh"))
        , ("M-p", spawn (scripts ++ "dmenu_displayselect.sh"))
        , ("M-g", spawn "doublecmd")
        , ("M-C-l", spawn "xautolock -locknow")
        , ("M-a", spawn (scripts ++ "dmenu_websearch.sh"))
        , ("M-u", spawn (scripts ++ "dmenu_umount.sh"))
        , ("M-S-c", spawn (scripts ++ "xcolor_pick.sh"))
        , ("M-S-C-p", spawn "keepassxc")

        -- Meh
        , ("C-S-M1-m", spawn "$MYTERM -t ncmpcpp -e sh -c 'while true; do ncmpcpp; done'")
        , ("C-S-M1-q", spawn "qgis")
        , ("C-S-M1-r", spawn "rstudio-bin")
        , ("C-S-M1-t", spawn "thunderbird")
        , ("C-S-M1-a", spawn "pavucontrol")
        , ("C-S-M1-s", spawn "signal-desktop")
        , ("C-S-M1-d", spawn "telegram-desktop")
        , ("C-S-M1-b", spawn "blueman-manager")

        -- Emacs
        , ("M-e e", spawn "emacsclient -c -a 'emacs'")
        , ("M-e c", spawn "emacsclient -c -a 'emacs' -e '(org-capture)'")
        , ("M-e m", spawn "emacsclient -c -a 'emacs' -e '(mu4e)'")
        , ("M-e q", spawn (scripts ++ "restart_emacs.sh"))
        
        -- Weather
        --, ("M-w w", spawn (scripts ++ "dmenu_wttr.sh"))
        --, ("M-w r", spawn (scripts ++ "wetterradar.sh"))

        -- Help
        , ("M-z k", spawn ("$MYTERM -e '" ++ scripts ++ "xmonad_keys.sh'"))
        , ("M-z l", spawn "zathura /home/loki/Nextcloud/currentEZlayout.pdf")
        , ("M-z r", spawn (scripts ++ "dmenu_R-pdfs.sh"))

        -- Laptop
        , ("<XF86MonBrightnessUp>", spawn (scripts ++ "brightness.sh +"))
        , ("<XF86MonBrightnessDown>", spawn (scripts ++ "brightness.sh -"))
        , ("M-<F11>", spawn (scripts ++ "toggle_touchpad.sh"))

        -- Screenshots / scratchpads
        , ("M-s f", spawn (scripts ++ "screenshot_full.sh"))
        , ("M-s r", spawn (scripts ++ "screenshot_region.sh"))
        , ("M-s x", spawn "xset r rate 260 35")
        , ("M-s c", namedScratchpadAction myScratchPads "calc")
        , ("M-s d", namedScratchpadAction myScratchPads "calendar")

        -- Media
        , ("<XF86AudioPlay>", spawn "mpc toggle > /dev/null")
        , ("<XF86AudioNext>", spawn "mpc next > /dev/null")
        , ("<XF86AudioPrev>", spawn "mpc prev > /dev/null")
        , ("<XF86AudioMicMute>", spawn (scripts ++ "toggle_microphone.sh"))
        , ("<XF86AudioMute>", spawn (scripts ++ "adjust_volume.sh m"))
        , ("<XF86AudioRaiseVolume>", spawn (scripts ++ "adjust_volume.sh +"))
        , ("<XF86AudioLowerVolume>", spawn (scripts ++ "adjust_volume.sh -"))


        ] ++ [
        -- Extra Workspaces: https://stackoverflow.com/a/27743913/3250126
          (("M-" ++ key), (windows $ W.greedyView ws)) | (key, ws) <- myExtraWorkspaces
        ] ++ [
          (("M-S-" ++ key), (windows $ W.shift ws)) | (key, ws) <- myExtraWorkspaces
        ] -- ++ [
          --(("M-C-" ++ key), (windows $ copy ws)) | (key, ws) <- zip ["1","2","3","4","5","6","7","8","9"] wrkspcs
        --, (("M-C-" ++ key), (windows $ copy ws)) | (key, ws) <- myExtraWorkspaces
        --     ]

----------------------------------------------------------------------
-- Workspaces
----------------------------------------------------------------------
myExtraWorkspaces = [("0", "0:\xf0e0"), ("ß", "ß:\xf11b")] -- https://stackoverflow.com/a/27743913/3250126
wrkspcs = ["1:\xf269", "2:\xf15c", "3:\xf120", "4:\xfcd2", "5:\xf07c"
               , "6:\xf001", "7:\xf0ac", "8:\xf1dd", "9:\xf1fc"]
myWorkspaces = wrkspcs ++ (map snd myExtraWorkspaces)
        -- Unicode escape chars: https://stackoverflow.com/q/60682325/3250126


------------------------------------------------------------------------
-- SCRATCHPADS
------------------------------------------------------------------------
myScratchPads :: [NamedScratchpad]
myScratchPads = [ NS "calc" spawnTerm findQalc manageTerm
                , NS "calendar" spawnCal findCal manageCal
                ]
    where
    spawnTerm  = myTerminal ++  " -t qalc -e qalc"
    findQalc   = title =? "qalc"
    manageTerm = customFloating $ W.RationalRect (1/4) (1/4) (1/2) (1/2)
    spawnCal   = myTerminal ++ " -t calendar --hold -e /usr/bin/cal -y"
    findCal    = title =? "calendar"
    manageCal  = customFloating $ W.RationalRect (0.325) (1/6) (0.35) (0.55)

