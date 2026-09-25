module FFMPEGExt

import FFMPEG
import Plots

Plots.ffmpeg_exe(command::Cmd) = FFMPEG.ffmpeg_exe(command)

end
