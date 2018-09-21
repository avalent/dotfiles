--
-- An example, simple ~/.xmonad/xmonad.hs file.
-- It overrides a few basic settings, reusing all the other defaults.
--

import XMonad
import XMonad.Config.Kde
import XMonad.Config.Xfce
import System.IO
import System.Exit
import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.SetWMName
import XMonad.Layout.Fullscreen
import XMonad.Layout.NoBorders
import XMonad.Layout.Spiral
import XMonad.Layout.Tabbed
import XMonad.Layout.ThreeColumns
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys, additionalKeysP)
import Graphics.X11.ExtraTypes.XF86
import qualified XMonad.StackSet as W
import qualified Data.Map        as M


------------------------------------------------------------------------
-- Layouts
-- You can specify and transform your layouts by modifying these values.
-- If you change layout bindings be sure to use 'mod-shift-space' after
-- restarting (with 'mod-q') to reset your layout state to the new
-- defaults, as xmonad preserves your old layout settings by default.
--
-- The available layouts.  Note that each layout is separated by |||,
-- which denotes layout choice.
--
myLayout = avoidStruts (
    ThreeColMid 1 (3/100) (1/2) |||
    Tall 1 (3/100) (1/2) |||
    Mirror (Tall 1 (3/100) (1/2)) |||
    tabbed shrinkText tabConfig |||
    Full |||
    spiral (6/7)) |||
    noBorders (fullscreenFull Full)


------------------------------------------------------------------------
-- Colors and borders
-- Currently based on the ir_black theme.
--
myNormalBorderColor  = "#7c7c7c"
myFocusedBorderColor = "#ffb6b0"

-- Colors for text and backgrounds of each tab when in "Tabbed" layout.
tabConfig = defaultTheme {
    activeBorderColor = "#7C7C7C",
    activeTextColor = "#CEFFAC",
    activeColor = "#000000",
    inactiveBorderColor = "#7C7C7C",
    inactiveTextColor = "#EEEEEE",
    inactiveColor = "#000000"
}

-- Color of current window title in xmobar.
xmobarTitleColor = "#FFB6B0"

-- Color of current workspace in xmobar.
xmobarCurrentWorkspaceColor = "#CEFFAC"

-- Width of the window border in pixels.
myBorderWidth = 1

------------------------------------------------------------------------
-- Terminal
-- The preferred terminal program, which is used in a binding below and by
-- certain contrib modules.
--
myTerminal = "terminator"

-- The command to lock the screen or show the screensaver.
myScreensaver = "/usr/bin/gnome-screensaver-command --lock"

-- The command to take a selective screenshot, where you select
-- what you'd like to capture on the screen.
mySelectScreenshot = "/home/avalent/.xmonad/bin/select-screenshot"

-- The command to take a fullscreen screenshot.
myScreenshot = "screenshot"

-- The command to use as a launcher, to launch commands that don't have
-- preset keybindings.
myLauncher = "$(/home/avalent/.cabal/bin/yeganesh -x -- -fn '-*-terminus-*-r-normal-*-*-120-*-*-*-*-iso8859-*' -nb '#000000' -nf '#FFFFFF' -sb '#7C7C7C' -sf '#CEFFAC')"

------------------------------------------------------------------------
-- Workspaces
-- The default number of workspaces (virtual screens) and their names.
--
myWorkspaces = ["1:term","2:web","3:code","4:vm","5:media"] ++ map show [6..9]

------------------------------------------------------------------------
-- Key bindings
--
-- modMask lets you specify which modkey you want to use. The default
-- is mod1Mask ("left alt").  You may also consider using mod3Mask
-- ("right alt"), which does not conflict with emacs keybindings. The
-- "windows key" is usually mod4Mask.
--
myModMask = mod1Mask

------------------------------------------------------------------------
-- Window rules
-- Execute arbitrary actions and WindowSet manipulations when managing
-- a new window. You can use this to, for example, always float a
-- particular program, or have a client always appear on a particular
-- workspace.
--
-- To find the property name associated with a program, use
-- > xprop | grep WM_CLASS
-- and click on the client you're interested in.
--
-- To match on the WM_NAME, you can use 'title' in the same way that
-- 'className' and 'resource' are used below.
--
myManageHook = composeAll
    [ className =? "Chromium"            --> doShift "2:web"
    , className =? "Google-chrome"       --> doShift "2:web"
    , resource  =? "desktop_window"      --> doIgnore
    , className =? "Galculator"          --> doFloat
    , className =? "Steam"               --> doFloat
    , className =? "Gimp"                --> doFloat
    , resource  =? "gpicview"            --> doFloat
    , className =? "MPlayer"             --> doFloat
    , className =? "VirtualBox"          --> doShift "4:vm"
    , className =? "Xchat"               --> doShift "5:media"
    , className =? "Slack"               --> doShift "5:media"
    , className =? "Spotify"             --> doShift "5:media"
    , className =? ".terminator-wrapped" --> doShift "1:term"
    , className =? "stalonetray"         --> doIgnore
    , className =? "albert"              --> doFloat
    , isFullscreen --> (doF W.focusDown <+> doFullFloat)]

{-main = xmonad kdeConfig-}
main = xmonad $ xfceConfig
                  { borderWidth        = 1
                  , normalBorderColor  = "#cccccc"
                  , focusedBorderColor = "#cd8b00"
                  , workspaces         = myWorkspaces
                  , manageHook         = myManageHook <+> manageHook xfceConfig
                  , layoutHook         = smartBorders $ myLayout
                  , terminal           = myTerminal
                  } `additionalKeysP` [ ("M-C-S-4", spawn mySelectScreenshot ) ]

              --     `additionalKeys` [ ((mod1Mask, xK_m        ), spawn "echo 'Hi, mom!' | dzen2 -p 4")
              --                        , ((modMask .|. controlMask .|. shiftMask, xK_4), spawn mySelectScreenshot)
              --                        ]

--main = xmonad $ def
--    { borderWidth        = 2
--    , terminal           = "urxvt"
--    , normalBorderColor  = "#cccccc"
--    , focusedBorderColor = "#cd8b00" }
