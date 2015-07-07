//
// Trigger file processing when drag a file and drop it onto a web page.
//
    if (FileReader){
        function cancelEvent(e){
            e.stopPropagation();
            e.preventDefault();
        }
        document.addEventListener('dragenter', cancelEvent, false);
        document.addEventListener('dragover', cancelEvent, false);
        document.addEventListener('drop', function(e){
            cancelEvent(e);
            for(var i=0;i            var
                file = e.dataTransfer.files[i]
            ;
            if(file.type != 'audio/midi' && file.type != 'audio/mid'){
                continue;
            }
            var
                reader = new FileReader()
            ;
            reader.onload = function(e){
                midiFile = MidiFile(e.target.result);
                synth = Synth(44100);
                replayer = Replayer(midiFile, synth);
                audio = AudioPlayer(replayer);
            };
            reader.readAsBinaryString(file);
            }
        }, false);
    }
