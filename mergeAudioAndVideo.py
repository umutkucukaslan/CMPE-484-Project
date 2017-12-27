
import subprocess

def our_function():
	FFMPEG_BIN = "ffmpeg"
	command = [ FFMPEG_BIN,
				'-i', 'sil.avi',
				'-i', 'sil.wav',
				'-c', 'copy',
				'out.MOV']
	subprocess.call(command, stdin=None, stdout=None, stderr=None, shell=False)
	command = ["rm", 'sil.avi', 'sil.wav']
	subprocess.call(command, stdin=None, stdout=None, stderr=None, shell=False)
our_function()