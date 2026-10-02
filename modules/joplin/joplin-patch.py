import sys
from pathlib import Path


root = Path(sys.argv[1])

matches = list(root.rglob("main.bundle.js"))

if not matches:
    raise SystemExit("Joplin patch: main.bundle.js not found")

main = matches[0]
text = main.read_text()


# Native Electron transparency
import re

pattern = r'backgroundColor:[A-Za-z_$][A-Za-z0-9_$]*\.nativeTheme\.shouldUseDarkColors\?"#333":"#fff"'
replacement = 'transparent:!0,backgroundColor:"#00000000"'

text, count = re.subn(pattern, replacement, text, count=1)

if count != 1:
    raise SystemExit(
        f"Joplin patch: native backgroundColor expression not found "
        f"(matches={count})"
    )


# Renderer transparency
marker = 'this.win_.webContents.on("did-fail-load",'

marker_pos = text.find(marker)

if marker_pos == -1:
    raise SystemExit(
        "Joplin patch: did-fail-load handler not found"
    )


handler = (
    'await this.handleAppFailure("Renderer process failed to load",!1)}),'
)

handler_pos = text.find(handler, marker_pos)

if handler_pos == -1:
    raise SystemExit(
        "Joplin patch: exact did-fail-load handler body not found"
    )

insert_pos = handler_pos + len(handler)


override = r'''
this.win_.webContents.on("did-finish-load",()=>{
  try{
    const w=this.win_.webContents;

    w.executeJavaScript(`(()=>{
      const ID="joplin-transparent-ui-override";

      const apply=()=>{
        const rootStyle="rgb(16, 21, 26)";

        for(const el of document.querySelectorAll("*")){
          const s=getComputedStyle(el);
          const r=el.getBoundingClientRect();

          if(
            s.backgroundColor===rootStyle &&
            (
              (r.width>800 && r.height>700) ||
              (r.width>400 && r.height>700)
            )
          ){
            el.style.setProperty(
              "background-color",
              "transparent",
              "important"
            );
          }
        }

        const title=document.querySelector(".title-input");
        if(title)
          title.style.setProperty(
            "background-color",
            "transparent",
            "important"
          );

        const toolbar=document.querySelector("#CodeMirrorToolbar");
        if(toolbar)
          toolbar.style.setProperty(
            "background-color",
            "transparent",
            "important"
          );

        const sidebar=document.querySelector(".sidebar");
        if(sidebar)
          sidebar.style.setProperty(
            "background-color",
            "transparent",
            "important"
          );

        const noteList=document.querySelector("#notes-list");
        if(noteList)
          noteList.style.setProperty(
            "background-color",
            "transparent",
            "important"
          );

        const newButtons=document.querySelector(".sc-kOHTFB.cAxSyf");
        if(newButtons)
          newButtons.style.setProperty(
            "background-color",
            "transparent",
            "important"
          );
      };

      if(!document.getElementById(ID)){
        const style=document.createElement("style");
        style.id=ID;

        style.textContent=\`
          body{
            background-color:#2c2c2c4d !important;
          }

          #notes-list .content.-selected{
            background-color:#10151a !important;
          }

          #notes-list .content:hover:not(.-selected){
            background-color:rgba(20,26,33,.5) !important;
          }
        \`;

        document.head.appendChild(style);
      }

      document.documentElement.style.setProperty(
        "background-color",
        "transparent",
        "important"
      );

      apply();

      if(!window.__joplinTransparencyObserver){
        const observer=new MutationObserver(()=>{
          apply();
        });

        observer.observe(document.body,{
          childList:true,
          subtree:true
        });

        window.__joplinTransparencyObserver=observer;
      }
    })()`,true).catch(()=>{});
  }catch(e){}
}),
'''


text = text[:insert_pos] + override + text[insert_pos:]

main.write_text(text)

print(f"Joplin patched: {main}")
