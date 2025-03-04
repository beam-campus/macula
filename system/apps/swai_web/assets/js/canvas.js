export const Canvas = (hook, pixels) => {
  const canvas = document.getElementById(hook.el.id);
  let ctx = canvas.getContext("2d");

  for (let x = 0; x < 30; x++) {
    for (let y = 0; y < 30; y++) {
      ctx.fillStyle = pixels[y];
      ctx.fillRect(y, x, 1, 1);
    }
    pixels.splice(0, 30);
  }
};


export const CellStateChanged = {
  mounted() {
    this.handleEvent("cell_state_changed", ({ cell_states }) => {
      this.el.dataset.cell_states = JSON.stringify(cell_states);
    });
  }
};

export const Canvas2 = {
  mounted() {
    let canvas = this.el.firstElementChild;
    let context = canvas.getContext("2d");
    let ratio = getPixelRatio(context);
    let colorizer = cubehelix(3, 0.5, 2.0);

    // Set the canvas width and height to match the parent div
    canvas.style.width = '100%';
    canvas.style.height = '100%';

    // Set the internal size to match
    canvas.width = canvas.offsetWidth;
    canvas.height = canvas.offsetHeight;

    resize(canvas, ratio);

    Object.assign(this, {
      canvas,
      colorizer,
      context,
      ratio,
      i: 0,
      j: 0,
      fps: 0,
      ups: 0
    });
  },
  updated() {
    let { canvas, colorizer, context, ratio } = this;
    let cell_states = JSON.parse(this.el.dataset.cell_states);
    let halfHeight = canvas.height / 2;
    let halfWidth = canvas.width / 2;
    let smallerHalf = Math.min(halfHeight, halfWidth);

    this.j++;
    if (this.j % 5 === 0) {
      this.j = 0;
      let now = performance.now();
      this.ups = 1 / ((now - (this.upsNow || now)) / 5000);
      this.upsNow = now;
    }

    if (this.animationFrameRequest) {
      cancelAnimationFrame(this.animationFrameRequest);
    }

    this.animationFrameRequest = requestAnimationFrame(() => {
      this.animationFrameRequest = undefined;


      // context.fillStyle = "transparent";
      context.fillStyle = "#55bb00";
      context.fillRect(0, 0, canvas.width, canvas.height);

      fade(canvas, context, 0.8);

      cell_states.forEach(state => {
        oldFont = context.font;
        context.font = "20px Arial";
        posX = (state.col * 2)
        posY = 60 + (state.row * 1)
        context.fillText(state.content, posX, posY);
        context.font = oldFont;
      })

      this.i++;
      if (this.i % 5 === 0) {
        this.i = 0;
        let now = performance.now();
        this.fps = 1 / ((now - (this.fpsNow || now)) / 5000);
        this.fpsNow = now;
      }

      context.textBaseline = "top";
      context.font = "8pt monospace";
      context.fillStyle = "#f0f0f0";
      context.beginPath();
      context.rect(0, 0, 160, 40);
      context.fill();
      context.fillStyle = "black";
      context.fillText(`Client FPS: ${Math.round(this.fps)}`, 10, 10);
      context.fillText(`Server FPS: ${Math.round(this.ups)}`, 10, 22);
    });
  }
};


const getPixelRatio = context => {
  var backingStore =
    context.backingStorePixelRatio ||
    context.webkitBackingStorePixelRatio ||
    context.mozBackingStorePixelRatio ||
    context.msBackingStorePixelRatio ||
    context.oBackingStorePixelRatio ||
    context.backingStorePixelRatio ||
    1;

  return (window.devicePixelRatio || 1) / backingStore;
};

const fade = (canvas, context, amount) => {
  context.beginPath();
  context.rect(0, 0, canvas.width, canvas.height);
  context.fillStyle = `rgba(255, 255, 255, ${amount})`;
  context.fill();
};

const resize = (canvas, ratio) => {
  canvas.width = window.innerWidth * ratio;
  canvas.height = window.innerHeight * ratio;
  canvas.style.width = `${window.innerWidth}px`;
  canvas.style.height = `${window.innerHeight}px`;
};

const cubehelix = (s, r, h) => d => {
  let t = 2 * Math.PI * (s / 3 + r * d);
  let a = (h * d * (1 - d)) / 2;
  return [
    d + a * (-0.14861 * Math.cos(t) + Math.sin(t) * 1.78277),
    d + a * (-0.29227 * Math.cos(t) + Math.sin(t) * -0.90649),
    d + a * (1.97294 * Math.cos(t) + Math.sin(t) * 0.0)
  ];
};