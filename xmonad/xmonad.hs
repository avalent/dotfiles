--
-- An example, simple ~/.xmonad/xmonad.hs file.
-- It overrides a few basic settings, reusing all the other defaults.
--

import XMonad
import XMonad.Config.Kde
import XMonad.Config.Xfce

{-main = xmonad kdeConfig-}
main = xmonad xfceConfig
                { borderWidth        = 2
                , terminal           = "urxvt"
                , normalBorderColor  = "#cccccc"
                , focusedBorderColor = "#cd8b00"
                }

--main = xmonad $ def
--    { borderWidth        = 2
--    , terminal           = "urxvt"
--    , normalBorderColor  = "#cccccc"
--    , focusedBorderColor = "#cd8b00" }
