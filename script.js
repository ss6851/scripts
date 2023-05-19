let btn = document.createElement("button");
btn.innerText = 'Submit File';
btn.style.backgroundColor = 'green';
btn.style.color = 'white';
btn.style.padding = '5px';
btn.style.border = 'none';
btn.style.borderRadius = '5px';
btn.style.margin = '5px';

let progressContainer = document.createElement("div");
progressContainer.style.width = '99%';
progressContainer.style.height = '5px';
progressContainer.style.backgroundColor = 'grey';

let progressBar = document.createElement("div");
progressBar.style.width = '0%';
progressBar.style.height = '100%';
progressBar.style.backgroundColor = 'blue';
progressContainer.appendChild(progressBar);

let targetElement = document.querySelector('.flex.flex-col.w-full.py-2.flex-grow.md\:py-3.md\:pl-4');
targetElement.parentNode.insertBefore(btn, targetElement);
targetElement.parentNode.insertBefore(progressContainer, targetElement);

btn.addEventListener('click', async function() {
    let fileInput = document.createElement('input');
    fileInput.type = 'file';
    fileInput.accept = '.txt,.js,.py,.html,.css,.json,.csv';
    fileInput.click();

    fileInput.addEventListener('change', async function() {
        let file = fileInput.files[0];
        let reader = new FileReader();
        reader.readAsText(file);

        reader.onload = async function() {
            let text = reader.result;
            let chunkSize = 15000;
            let numChunks = Math.ceil(text.length / chunkSize);
            for (let i = 0; i < numChunks; i++) {
                let chunk = text.slice(i * chunkSize, (i + 1) * chunkSize);
                await submitConversation(chunk, i + 1, file.name);
                progressBar.style.width = `${((i + 1) / numChunks) * 100}%`;

                let chatgptReady = false;
                while (!chatgptReady) {
                    await new Promise(resolve => setTimeout(resolve, 1000));
                    chatgptReady = !document.querySelector(".text-2xl ＞ span:not(.invisible)");
                }
            }

            progressBar.style.backgroundColor = 'green';
        };
    });
});

async function submitConversation(text, part, filename) {
    const textarea = document.querySelector("textarea[tabindex='0']");
    const enterKeyEvent = new KeyboardEvent("keydown", {
        bubbles: true,
        cancelable: true,
        keyCode: 13,
    });
    textarea.value = `Part ${part} of ${filename}: \n\n ${text}`;
    textarea.dispatchEvent(enterKeyEvent);
}
