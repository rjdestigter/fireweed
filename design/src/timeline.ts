console.clear();
var PIXEL_RATIO = (function () {
  var ctx: any = document.createElement("canvas")!.getContext("2d")!,
    dpr = window.devicePixelRatio || 1,
    bsr =
      ctx.webkitBackingStorePixelRatio ||
      ctx.mozBackingStorePixelRatio ||
      ctx.msBackingStorePixelRatio ||
      ctx.oBackingStorePixelRatio ||
      ctx.backingStorePixelRatio ||
      1;

  return dpr / bsr;
})();

const createHiDPICanvas = (w: number, h: number, ratio?: number) => {
  if (!ratio) {
    ratio = PIXEL_RATIO;
  }
  const can = document.createElement("canvas")!;
  can.width = w * ratio;
  can.height = h * ratio;
  can.style.width = w + "px";
  can.style.height = h + "px";
  can.getContext("2d")!.setTransform(ratio, 0, 0, ratio, 0, 0);

  return can;
};

const elRoot = document.querySelector<HTMLDivElement>("[data-timeline]")!;
const elAnchor = document.querySelector<HTMLDivElement>("[data-timeline]>div")!;
const elEvent = document.querySelector<HTMLDivElement>("[data-event]")!;
const { width, height } = elRoot.getBoundingClientRect();

//Create canvas with the device resolution.
var canvas = createHiDPICanvas(width, height);

elRoot.prepend(canvas);
const ctx = canvas.getContext("2d")!;

const dtf_seconds = new Intl.DateTimeFormat("nl", {
  second: "numeric",
});

const dtf = new Intl.DateTimeFormat("nl", {
  hour: "numeric",
  minute: "numeric",
  second: "numeric",
});

const now = Date.now();
const start = now - +dtf_seconds.format(now) * 1000;
let zoom = 1;
const pan = 0;

elEvent.style.transform = `translateY(${500}px)`;

function render(y: number = 0) {
  elEvent.style.transform = `translateY(calc(${y + (240 * zoom)}px - 50%))`;

  ctx.clearRect(0, 0, width, height);
  ctx.beginPath();
  ctx.strokeStyle = "#cccccc";
  ctx.lineWidth = 1;

  const range = Math.ceil(height);

  ctx.fillStyle = "Pink";

  //   ctx.fillText("" + y, 100, 100);
  //   ctx.fillStyle = "Cyan";
  //   ctx.fillText(dtf.format(start), 200, 200);
  //   ctx.fill();

  Array.from(Array(range)).forEach((_, index) => {
    const yindex = index - y;
    ctx.beginPath();
    ctx.fillStyle = "Cyan";

    if (yindex % (300 * zoom) === 0) {
      ctx.rect(width - (zoom >= 10 ? 200 : 150), index - 1.5, width, 3);
      ctx.fill();
      const time = start + (yindex / zoom) * 1000;
      ctx.fillText(dtf.format(time), width - 110, index + 0.5 - 10);
    } else if (yindex % (60 * zoom) === 0) {
      ctx.strokeStyle = "#fafafa";
      ctx.moveTo(width - (zoom >= 10 ? 200 : 120), index + 0.5);
      ctx.lineTo(width, index + 0.5);
      ctx.stroke();
      const time = start + (yindex / zoom) * 1000;
      ctx.fillText(dtf.format(time), width - 110, index + 0.5 - 10);
    } else if (yindex % (5 * zoom) === 0) {
      ctx.strokeStyle = zoom >= 10 ? "Cyan" : "#666";
      ctx.moveTo(width - (zoom >= 10 ? 150 : 50), index + 0.5);
      ctx.lineTo(width, index + 0.5);
      ctx.stroke();

      if (zoom >= 10) {
        const time = start + (yindex / zoom) * 1000;
        ctx.fillText(dtf.format(time), width - 110, index + 0.5 - 10);
      }
    } else if (zoom >= 10 && yindex % 5 === 0) {
      ctx.strokeStyle = "#999";
      ctx.moveTo(width - 50, index + 0.5);
      ctx.lineTo(width, index + 0.5);
      ctx.stroke();
    }
  });
}

ctx.beginPath();
ctx.strokeStyle = "#fafafa";
ctx.font = "0.8rem sans-serif";
ctx.fillStyle = "#fafafa";

let y = 0;

render(y);

const onMouseDown = ({ clientY: yy }: MouseEvent) => {
  let _y = 0;
  const onMouseMove = ({ clientY: yyy }: MouseEvent) => {
    _y = y + yyy - yy;
    render(_y);
  };

  canvas.addEventListener("mousemove", onMouseMove);

  canvas.addEventListener(
    "mouseup",
    () => {
      y = _y;
      canvas.removeEventListener("mousemove", onMouseMove);
    },
    { once: true }
  );
};

window.addEventListener("mousedown", onMouseDown);

canvas.addEventListener("wheel", (e) => {
  e.preventDefault();
  if (e.ctrlKey) {
    zoom += Math.round(e.deltaY * -0.01);
    zoom = Math.min(Math.max(1, zoom), 20);
    console.log(e.deltaY, e.deltaY * -0.01, zoom);
  } else {
    y += Math.ceil(e.deltaY * -1);
  }

  render(y);
});
