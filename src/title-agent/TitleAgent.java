import java.awt.Frame;
import java.awt.Window;
import java.lang.instrument.Instrumentation;
import java.util.Timer;
import java.util.TimerTask;

public class TitleAgent {
    public static void premain(final String suffix, Instrumentation inst) {
        if (suffix == null || suffix.trim().isEmpty()) return;

        Timer timer = new Timer("TitleWatcher", true);
        timer.scheduleAtFixedRate(new TimerTask() {
            @Override
            public void run() {
                for (Window w : Window.getWindows()) {
                    if (w instanceof Frame) {
                        Frame f = (Frame) w;
                        String title = f.getTitle();
                        if (title != null && title.startsWith("Gertec TC Server") && !title.endsWith(suffix)) {
                            f.setTitle(title + suffix);
                        }
                    }
                }
            }
        }, 1000, 1000);
    }
}
