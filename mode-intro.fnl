(import-macros {: incf} :sample-macros)

(var counter 0)
(var time 0)

(love.graphics.setNewFont 30)

(local (major minor revision) (love.getVersion))
(local fennel (require :lib.fennel))
(fn pp [x] (print (fennel.view x)))


(fn generate-toggle-fullscreen []
  (var (_w _h previous-flags) (love.window.getMode))
  (set previous-flags.w _w)
  (set previous-flags.h _h)
  (fn  []
    (local lume (require :lib.lume))
    (if (= :Web (love.system.getOS))
        (JS.callJS "toggleFullScreen();")
        (do
          (local (w h flags) (love.window.getMode))
          (pp [:flags flags.x flags.y])
          (pp [:previous previous-flags.x previous-flags.y])
     (if flags.fullscreen         
         (do
           (tset flags :fullscreen false)
           (set flags.x previous-flags.x)
           (set flags.y previous-flags.y)
           (love.window.setMode previous-flags.w previous-flags.h flags))
         (do
           (tset flags :fullscreen true)
           (love.window.setMode w h flags)))
     (set previous-flags (lume.clone flags))
     (set previous-flags.w w)
     (set previous-flags.h h)
     (love.resize (love.window.getMode))))))

(local toggle-fullscreen (generate-toggle-fullscreen))


{:init (fn init [])
 :draw (fn draw [message]
         (local (w h _flags) (love.window.getMode))
         (love.graphics.printf
          (: "Love Version: %s.%s.%s"
             :format  major minor revision) 0 10 w :center)
         (love.graphics.printf
          (: "This window should close in %0.1f seconds"
             :format (math.max 0 (- 3 time)))
          0 (- (/ h 2) 15) w :center))
 :update (fn update [dt set-mode]
             (if (< counter 65535)
                 (set counter (+ counter 1))
                 (set counter 0))
             (incf time dt)
             (when (> time 3)
               (set time 0)
               ;;(love.event.quit)
               ))
 :keypressed (fn keypressed [key set-mode]
               (match key
                 :a (toggle-fullscreen)))}
