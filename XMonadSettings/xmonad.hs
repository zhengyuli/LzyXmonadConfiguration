-- Import stuff
import XMonad
import System.IO 
import Data.Ratio
import System.Exit
import qualified Data.Map as M
import qualified XMonad.StackSet as W
-- Import prompt
import XMonad.Prompt
import XMonad.Prompt.Shell
-- Import util
import XMonad.Util.Run
import XMonad.Util.Scratchpad
import XMonad.Util.NamedScratchpad
-- Import hooks
import XMonad.Hooks.SetWMName
--import XMonad.Hooks.ICCCMFocus
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.UrgencyHook
import XMonad.Hooks.FadeWindows
-- Import layout
import XMonad.Layout.IM
import XMonad.Layout.Grid
import XMonad.Layout.Tabbed
import XMonad.Layout.Reflect
import XMonad.Layout.NoBorders
import XMonad.Layout.Magnifier
import XMonad.Layout.ResizableTile
import XMonad.Layout.PerWorkspace
-- Import action
import XMonad.Actions.WindowGo
import XMonad.Actions.GridSelect
import XMonad.Actions.CycleWS

-----------------------------------------------------------------------------------
-- Terminal
myTerminal :: String
myTerminal = "/usr/bin/urxvt"

-- Workspaces
myWorkspaces :: [WorkspaceId]
myWorkspaces = ["1:Main","2:Emacs","3:Web","4:Media", "5:IM", "6:Gimp", "7:VM", "8:Doc", "9:TeamViewer"]

-----------------------------------------------------------------------------------
-- Main
main = do
  xmproc <- spawnPipe "xmobar ~/.xmonad/xmobar.hs"
  xmonad $ withUrgencyHook NoUrgencyHook $ defaultConfig
       {
         -- simple stuff
         terminal = myTerminal
       , modMask = myModMask
       , workspaces = myWorkspaces
       , borderWidth = myBorderWidth
       , normalBorderColor = myNormalBorderColor
       , focusedBorderColor = myFocusedBorderColor
       , focusFollowsMouse = myFocusFollowsMouse
       -- key bindings
       , keys = myKeys
       , mouseBindings = myMouseBindings
       -- hooks, layouts
       , layoutHook = myLayoutHook
       , manageHook = myManageHook
       , logHook = myLogHook xmproc >> fadeWindowsLogHook myFadeHook
       , handleEventHook = fullscreenEventHook <+> fadeWindowsEventHook
       }

-----------------------------------------------------------------------------------
-- Hooks
-- ManageHook
myManageHook :: ManageHook
myManageHook = (composeAll.concat $
                [[isFullscreen --> doFullFloat
                 , className =? "Firefox" --> doShift "3:Web"
                 , className =? "Google-chrome" --> doShift "3:Web"
                 , className =? "Chromium" --> doShift "3:Web"
                 , className =? "Chromium-browser" --> doShift "3:Web"
                 , className =? "Emacs" --> doShift "2:Emacs"
                 , className =? "MPlayer" --> doFloat <+> doShift "4:Media"
                 , className =? "Skype" --> doShift "5:IM"
                 , className =? "Pidgin" --> doShift "5:IM"
                 , className =? "Gimp" --> doShift "6:Gimp"
                 , className =? "VirtualBox" --> doShift "7:VM"
                 , className =? "Stardict" --> doFloat <+> doShift "8"
                 , className =? "Wine" --> doShift "9:TeamViewer"
                 ]]
               ) <+> (namedScratchpadManageHook scratchpads) <+> manageDocks

-- Scratchpad
scratchpads =
    [
     -- run htop in xterm, find it by title, use default floating window placement
     NS "htop" "xterm -e htop" (title =? "htop") (customFloating $ W.RationalRect (0) (1/35) (1/2) (34/35))
    -- run stardict, find it by class name, place it in the floating window
    -- 1/6 of screen width from the left, 1/6 of screen height
    -- from the top, 2/3 of screen width by 2/3 of screen height
    , NS "stardict" "stardict" (className =? "Stardict") (customFloating $ W.RationalRect (1/6) (1/6) (2/3) (2/3))
    , NS "goagent" "xterm -e proxy" (title =? "proxy") (customFloating $ W.RationalRect (0) (1/35) (1/2) (34/35))
    ]

-- LogHook
myLogHook h = dynamicLogWithPP $ customPP
              {
                ppOutput = hPutStrLn h
              }

myFadeHook = composeAll
             [ transparency 0.05
             , className =? "Emacs" --> transparency 0.10
             , className =? "Firefox" --> opaque
             , className =? "Google-chrome" --> opaque
             , className =? "Chromium" --> opaque
             , className =? "Chromium-browser" --> opaque
             , className =? "MPlayer" --> opaque
             , className =? "Skype" --> opaque
             , className =? "Pidgin" --> opaque
             , className =? "Gimp" --> opaque
             , className =? "VirtualBox" --> opaque
             , className =? "Eclipse" --> opaque
             , className =? "eclipse" --> opaque
             , className =? "ADT" --> opaque
             , className =? "retext" --> opaque
             , className =? "Retext" --> opaque
             ]

-----------------------------------------------------------------------------------
-- Looks
-- Border colors
myNormalBorderColor :: String
myNormalBorderColor  = "#1f1f1f"
myFocusedBorderColor :: String
myFocusedBorderColor = "#2f2f2f"

-- Color of current window title in xmobar.
xmobarTitleColor :: String
xmobarTitleColor = "#00aae0"

-- Color of current workspace in xmobar.
xmobarCurrentWorkspaceColor :: String
xmobarCurrentWorkspaceColor = "cyan"

-- borders
myBorderWidth :: Dimension
myBorderWidth = 1

-- Colors for text and backgrounds of each tab when in "Tabbed" layout.
---- bar
customPP :: PP
customPP = defaultPP
           { 
             ppCurrent = xmobarColor xmobarCurrentWorkspaceColor "" . wrap "[" "]"
           , ppTitle = xmobarColor xmobarTitleColor "" . shorten 1
           , ppSep = "  "
           }

-- My Theme For Tabbed layout
myTabTheme :: Theme
myTabTheme = defaultTheme
             {
               fontName = "xft:Bitstream Vera Sans Mono:size=9"
             , activeBorderColor = "#6f6f6f"
             , activeTextColor = "#00afff"
             , activeColor = "#000000"
             , inactiveBorderColor = "#2f2f2f"
             , inactiveTextColor = "#657b83"
             , inactiveColor = "#000000"
             }

myXPConfig :: XPConfig
myXPConfig = defaultXPConfig
             { font                  = "xft:Bitstream Vera Sans Mono:size=10"
             , bgColor               = "#101010"
             , fgColor               = "#00ccff"
             , bgHLight              = "#202020"
             , fgHLight              = "#ff00a0"
             , borderColor           = "#101010"
             , promptBorderWidth     = 1
             , height                = 21
             , position              = Top
             , historySize           = 100
             , historyFilter         = deleteConsecutive
             }

-----------------------------------------------------------------------------------
-- Layout
myLayoutHook = onWorkspace "3:Web" webLayout $ onWorkspace "5:IM" imLayout $ onWorkspace "6:Gimp" gimpLayout $ onWorkspace "7:VM" vmLayout $ standardLayouts
    where
      standardLayouts = avoidStruts $ (tiled ||| reflectTiled ||| Mirror tiled ||| Grid ||| full) ||| Full

-- standardLayouts
-- tiled layout
tiled = smartBorders (ResizableTall nmaster delta ratio [])
    where
      -- The default number of windows in the master pane
      nmaster = 1
      -- Percent of screen to increment by when resizing panes
      delta   = 2/100
      -- Default proportion of screen occupied by master pane
      ratio   = 1/2

-- reflectTiled layout
reflectTiled = (reflectHoriz tiled)

-- tabs layout
tabLayout = (tabbed shrinkText myTabTheme)

-- full layout
full = noBorders Full

-- im layout
imLayout = avoidStruts $ smartBorders
           $ withIM pidginRatio pidginRoster $ reflectHoriz
           $ withIM skypeRatio skypeRoster $ reflectHoriz
           (tiled ||| reflectTiled ||| Grid)
    where
      pidginRatio = (1/8)
      skypeRatio = (1/8)
      pidginRoster = And (ClassName "Pidgin") (Role "buddy_list")
      skypeRoster = (ClassName "Skype") `And` (Not (Title "Options")) `And` (Not (Role "ConversationsWindow")) `And` (Not (Role "CallWindow"))

-- gimp layout
gimpLayout = avoidStruts $ smartBorders $ withIM (11/100) (Role "gimp-toolbox") $ reflectHoriz $ withIM (15/100) (Role "gimp-dock") Full

--web layout
webLayout = avoidStruts $ (tiled ||| reflectTiled ||| full ||| tabLayout)

-- vm layout
vmLayout = avoidStruts $ full

------------------------------------------------------------------------
-- key bindings
-- modmask
myModMask :: KeyMask
myModMask = mod4Mask

-- GridSelect color scheme
myColorizer :: Window -> Bool -> X (String, String)
myColorizer = colorRangeFromClassName
              (0x20,0x20,0x20) -- lowest inactive bg
              (0xA0,0x20,0x50) -- highest inactive bg
              (0x44,0xAA,0xFF) -- active bg
              (0xA0,0xA0,0xA0) -- inactive fg
              (0x00,0x00,0x00) -- active fg

-- GridSelect config
myGSConfig :: t -> GSConfig Window
myGSConfig colorizer = (buildDefaultGSConfig myColorizer)
	               { gs_cellheight = 50
	               , gs_cellwidth = 200
	               , gs_cellpadding = 10
	               , gs_font = "xft:Bitstream Vera Sans Mono:size=10"
	               }

myKeys conf@(XConfig {XMonad.modMask = modMask}) = M.fromList $
  -- Start a terminal.  Terminal to start is specified by myTerminal variable.
  [ ((modMask .|. shiftMask, xK_Return),
     spawn $ XMonad.terminal conf)

  -- Close focused window.
  , ((modMask .|. shiftMask, xK_k),
     kill)

  -- Start grid select
  , ((modMask, xK_k),
     goToSelected $ myGSConfig myColorizer)

  --Launch Xmonad shell prompt
  , ((modMask, xK_p),
     shellPrompt myXPConfig)

  -- Next workspace
  , ((modMask, xK_Right),
     nextWS)

  -- Previous workspace
  , ((modMask, xK_Left),
     prevWS)

  -- Next screen
  , ((modMask, xK_n),
     nextScreen)

  -- Shift to next screen
  , ((modMask .|. shiftMask, xK_n),
     shiftNextScreen)

  -- Toggle WS
  , ((modMask, xK_x),
     toggleWS)

  -- Lock the screen using slimlock.
  , ((modMask .|. controlMask, xK_l),
     spawn "xlock")

  -- scratchpad
  , ((modMask, xK_a), namedScratchpadAction scratchpads "htop")
  , ((modMask, xK_s), namedScratchpadAction scratchpads "stardict")
  , ((modMask, xK_d), namedScratchpadAction scratchpads "goagent")

  -- That is, take a screenshot of everything you see.
  , ((modMask .|. shiftMask, xK_p),
     spawn "scrot '%Y-%m-%d_$wx$h.png' -e 'mv $f ~/Pictures/'")

  -- Mute volume.
  , ((modMask, xK_0),
     spawn "amixer -D pulse set Master 1+ toggle")

  -- Increase volume and beep.
  , ((modMask, xK_Up),
     spawn "amixer -q set Master 2dB+")

  -- Decrease volume and beep.
  , ((modMask, xK_Down),
     spawn "amixer -q set Master 2dB-")

  -- Cycle through the available layout algorithms.
  , ((modMask, xK_space),
     sendMessage NextLayout)

  --  Reset the layouts on the current workspace to default.
  , ((modMask .|. shiftMask, xK_space),
     setLayout $ XMonad.layoutHook conf)

  -- Move focus to the next window.
  , ((modMask, xK_Tab),
     windows W.focusDown)

  -- Move focus to the next window.
  , ((modMask, xK_j),
     windows W.focusDown)

  -- Move focus to the master window.
  , ((modMask, xK_m),
     windows W.focusMaster  )

  -- Shrink the master area.
  , ((modMask, xK_h),
     sendMessage Shrink)

  -- Expand the master area.
  , ((modMask, xK_l),
     sendMessage Expand)

  -- Push window back into tiling.
  , ((modMask, xK_t),
     withFocused $ windows . W.sink)

  -- Increment the number of windows in the master area.
  , ((modMask, xK_u),
     sendMessage (IncMasterN 1))

  -- Decrement the number of windows in the master area.
  , ((modMask, xK_i),
     sendMessage (IncMasterN (-1)))

  -- Quit xmonad.
  , ((modMask .|. shiftMask, xK_q),
     io (exitWith ExitSuccess))

  -- Restart xmonad.
  , ((modMask, xK_q),
     restart "xmonad" True)
  ]
  ++
  -- mod-[1..9], Switch to workspace N
  -- mod-shift-[1..9], Move client to workspace N
  [((m .|. modMask, k), windows $ f i)
      | (i, k) <- zip (workspaces conf) [xK_1 .. xK_9]
      , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
  ++
  -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
  -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
  [((m .|. modMask, key), screenWorkspace sc >>= flip whenJust (windows . f))
      | (key, sc) <- zip [xK_w, xK_e, xK_r] [0..]
      , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]

------------------------------------------------------------------------
-- Mouse bindings
-- Focus rules
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = False

myMouseBindings (XConfig {XMonad.modMask = modMask}) = M.fromList $
  [
    -- mod-button1, Set the window to floating mode and move by dragging
    ((modMask, button1),
     (\w -> focus w >> mouseMoveWindow w))

    -- mod-button2, Raise the window to the top of the stack
    , ((modMask, button2),
       (\w -> focus w >> windows W.swapMaster))

    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modMask, button3),
       (\w -> focus w >> mouseResizeWindow w))

    -- you may also bind events to the mouse scroll wheel (button4 and button5)
  ]
