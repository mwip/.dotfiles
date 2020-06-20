----------------------------------------------------------------------
-- Imports
----------------------------------------------------------------------
-- Xmonad
import XMonad
import XMonad.Config.Desktop
import Data.Monoid
import qualified XMonad.StackSet as W

-- Hooks
import XMonad.Hooks.DynamicLog (dynamicLogWithPP, defaultPP, wrap, pad, xmobarPP, xmobarColor, shorten, PP(..))
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
                        , ppCurrent = xmobarColor "#c3e88d" "" . wrap "[" "]" -- Current workspace in xmobar
                        , ppVisible = xmobarColor "#c3e88d" ""                -- Visible but not current workspace
                        , ppHidden = xmobarColor "#82AAFF" "" . wrap "*" ""   -- Hidden workspaces in xmobar
                        , ppHiddenNoWindows = xmobarColor "#444444" ""        -- Hidden workspaces (no windows)
                        , ppTitle = xmobarColor "#d0d0d0" "" . shorten 80     -- Title of active window in xmobar
                        , ppSep =  "<fc=#9AEDFE> : </fc>"                     -- Separators in xmobar
                        , ppUrgent = xmobarColor "#C45500" "" . wrap "!" "!"  -- Urgent workspace
                        , ppExtras  = [windowCount]                           -- # of windows current workspace
                        , ppOrder  = \(ws:l:t:ex) -> [ws,l]++ex++[t]
                        }

        , modMask = mod4Mask     -- Rebind Mod to the Windows key
        , terminal           = myTerminal
        , layoutHook         = myLayoutHook
        , startupHook        = myStartupHook
        , workspaces         = myWorkspaces
        , borderWidth        = myBorderWidth
        , normalBorderColor  = "#161616"
        , focusedBorderColor = "#ba0000"
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
     , className =? "QGIS3"                               --> doF W.swapDown
     -- dedicated workspaces
     , className =? "firefox"                             --> viewShift "1:\xf269"
     , className =? "Chromium"                            --> viewShift "1:\xf269"
     , className =? "Emacs"                               --> viewShift "2:\xf15c"
     , className =? "RStudio"                             --> viewShift "4:\xf25d"
     , className =? "Pcmanfm"                             --> viewShift "5:\xf07c"
     , className =? "Double Commander"                    --> viewShift "5:\xf07c"
     , title =? "ncmpcpp"                                 --> viewShift "6:\xf001"
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
     , className =? "KeePassXC"                           --> doCenterFloat
     , className =? "myCookbook"                          --> doFloat
     , title =?     "Media viewer"                        --> doFloat
     , title =?     "Select entry type"                   --> doFloat
     , className =? "Tor Browser"                         --> doCenterFloat
     , className =? "cloud-drive-ui"                      --> doCenterFloat
     , (className =? "firefox" <&&> resource =? "Dialog") --> doCenterFloat  -- Float Firefox Dialog
     ] <+> namedScratchpadManageHook myScratchPads
  where viewShift = doF . liftM2 (.) W.greedyView W.shift


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
          spawnOnce "/home/loki/.scripts/autostart.sh &"
          --spawnOnce "stalonetray" 
          setWMName "LG3D"

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
        , ("M-S-q", spawn (home ++ ".scripts/dmenu_exit.sh"))
        , ("M-y", nextScreen)
        , ("M-S-y", shiftNextScreen >> nextScreen)
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
        , ("M-f", spawn "firefox")
        , ("M-S-b", spawn (scripts ++ "pabluezswitch.sh"))
        , ("M-p", spawn (scripts ++ "dmenu_displayselect.sh"))
        , ("M-g", spawn (scripts ++ "dmenu_filemanager.sh"))
        , ("M-C-l", spawn "xautolock -locknow")
        , ("M-a", spawn (scripts ++ "dmenu_websearch.sh"))
        , ("M-u", spawn (scripts ++ "dmenu_umount.sh"))
        , ("M-S-c", spawn (scripts ++ "xcolor_pick.sh"))

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
        , ("M-e e", spawn myTextEditor)
        , ("M-e q", spawn "notify-send 'Emacs' 'Restarting Emacs Daemon' && killall emacs && emacs --daemon --chdir=$HOME && notify-send 'Emacs' 'Emacs Daemon restarted'")
        , ("M-c", spawn (scripts ++ "org-capture.sh"))
        
        -- Weather
        , ("M-w w", spawn (scripts ++ "dmenu_wttr.sh"))
        , ("M-w r", spawn (scripts ++ "wetterradar.sh"))

        -- Help
        , ("M-h k", spawn ("$MYTERM -e '" ++ scripts ++ "xmonad_keys.sh'"))
        , ("M-h l", spawn "zathura /home/loki/CloudStation/currentEZlayout.pdf")
        , ("M-h r", spawn (scripts ++ "dmenu_R-pdfs.sh"))

        -- Laptop
        , ("<XF86MonBrightnessUp>", spawn (scripts ++ "brightness.sh +"))
        , ("<XF86MonBrightnessDown>", spawn (scripts ++ "brightness.sh -"))
        , ("M-<F11>", spawn (scripts ++ "toggle_touchpad.sh"))

        -- Screenshots / scratchpads
        , ("M-s f", spawn (scripts ++ "screenshot_full.sh"))
        , ("M-s r", spawn (scripts ++ "screenshot_region.sh"))
        , ("M-s c", namedScratchpadAction myScratchPads "calc")

        -- Media
        , ("<XF86AudioPlay>", spawn "mpc toggle")
        , ("<XF86AudioNext>", spawn "mpc next")
        , ("<XF86AudioPrev>", spawn "mpc prev")
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
                ]
    where
    spawnTerm  = myTerminal ++  " -t qalc -e qalc"
    findQalc   = title =? "qalc"
    manageTerm = customFloating $ W.RationalRect (1/4) (1/4) (1/2) (1/2)

