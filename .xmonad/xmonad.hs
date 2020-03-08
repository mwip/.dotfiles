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

-- Utils
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeysP)
import XMonad.Util.SpawnOnce

-- Actions
import XMonad.Actions.CopyWindow (kill1)
import XMonad.Actions.WithAll (sinkAll, killAll)

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
import XMonad.Layout.IndependentScreens (countScreens)

-- System
import System.IO


myFont          = "xft:Ubuntu Mono Nerd Font:regular:pixelsize=12"
myModMask       = mod4Mask  -- Sets modkey to super/windows key
myTerminal      = "alacritty"      -- Sets default terminal
myTextEditor    = "emacsclient -c"     -- Sets default text editor
myBorderWidth   = 2         -- Sets border width for windows
myGaps          = 6
windowCount     = gets $ Just . show . length . W.integrate' . W.stack . W.workspace . W.current . windowset
home            = "/home/loki/"

main = do
    nScreens <- countScreens
    xmproc0 <- if nScreens > 1
      then spawnPipe "xmobar -x 0 -d /home/loki/.config/xmobar/xmobarrc0"
      else spawnPipe "/dev/null"
      
    xmproc1 <- spawnPipe "xmobar -x 1 -d /home/loki/.config/xmobar/xmobarrc1"
    xmonad $ ewmh desktopConfig
        { manageHook = manageDocks <+> myManageHook <+> manageHook desktopConfig
        , logHook = dynamicLogWithPP xmobarPP
                        { ppOutput = \x -> hPutStrLn xmproc1 x  >> hPutStrLn xmproc0 x
                        , ppCurrent = xmobarColor "#c3e88d" "" . wrap "[" "]" -- Current workspace in xmobar
                        , ppVisible = xmobarColor "#c3e88d" ""                -- Visible but not current workspace
                        , ppHidden = xmobarColor "#82AAFF" "" . wrap "*" ""   -- Hidden workspaces in xmobar
                        , ppHiddenNoWindows = xmobarColor "#F07178" ""        -- Hidden workspaces (no windows)
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
        , normalBorderColor  = "#292d3e"
        , focusedBorderColor = "#ba0000"
        } `additionalKeysP` myKeys


myManageHook :: Query (Data.Monoid.Endo WindowSet)
myManageHook = insertPosition Below Newer <+> composeAll
     [
        className =? "KeePassXC"   --> doFloat
      , (className =? "Firefox" <&&> resource =? "Dialog") --> doFloat  -- Float Firefox Dialog
     ]

--myLayoutHook = avoidStruts $ layoutHook desktopConfig $ smartBorders Tall ||| smartBorders Full
  --where
  --  tiled   = named "[]=" $ Tall 
  --  full    = named "[M]" $ Full
myLayoutHook = avoidStruts $ windowArrange $ smartBorders $
               mkToggle (NBFULL ?? NOBORDERS ?? EOT) $ myDefaultLayout
             where 
                 myDefaultLayout = tall ||| noBorders monocle

tall       = renamed [Replace "tall"]     $ limitWindows 12 $ spacing 6 $ ResizableTall 1 (3/100) (1/2) []
monocle    = renamed [Replace "monocle"]  $ limitWindows 20 $ Full


myStartupHook = do
          spawnOnce "/home/loki/.scripts/autostart.sh &"
          spawnOnce "stalonetray" 
          setWMName "LG3D"

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
        
        
        -- Windows
        , ("M-q", kill1)                           -- Kill the currently focused client
        , ("M-S-a", killAll)                       -- Kill all the windows on current workspace
        , ("M-f", sinkAll)                         -- Push all floating windows back to tile

        -- Terminal
        , ("M-<Return>", spawn myTerminal)

        -- Programs
        , ("M-r", spawn "/home/loki/.scripts/dmenu_recent.sh -fn 'Ubuntu Mono Nerd Font:size=11'")
        , ("M-C-<Return>", spawn "firefox")
        , ("C-M1-e", spawn "emacsclient -c -a ''")
        , ("M-c", spawn (home ++ ".scripts/org-capture.sh"))
        , ("M-S-b", spawn (home ++ ".scripts/pabluezswitch.sh"))
        , ("M-p", spawn (home ++ ".scripts/dmenu_displayselect.sh"))

        -- Laptop
        , ("<XF86MonBrightnessUp>", spawn (home ++ ".scripts/brightness.sh +"))
        , ("<XF86MonBrightnessDown>", spawn (home ++ ".scripts/brightness.sh -"))
        , ("<XF86AudioMicMute>", spawn (home ++ ".scripts/toggle_microphone.sh"))
        , ("<XF86AudioMute>", spawn (home ++ ".scripts/adjust_volume.sh m"))
        , ("<XF86AudioRaiseVolume>", spawn (home ++ ".scripts/adjust_volume.sh +"))
        , ("<XF86AudioLowerVolume>", spawn (home ++ ".scripts/adjust_volume.sh -"))

        -- Screenshots
        , ("M-s", spawn (home ++ ".scripts/screenshot_full.sh"))
        , ("M-S-s", spawn (home ++ ".scripts/screenshot_region.sh"))

        -- Media
        , ("<XF86AudioPlay>", spawn "mpc toggle")
        , ("<XF86AudioNext>", spawn "mpc next")
        , ("<XF86AudioPrev>", spawn "mpc prev")

        ]

--myWorkspaces :: [String]   
myWorkspaces = ["1:WWW", "2:EMX", "3:CMD", "4:R", "5:FLS", "6:MUX", "7:GIS", "8:DOC", "9:GFX"] 
        --["1:", "2:", "3:", "4:", "5:", "6:ﱘ", "7:", "8:", "9:"]
