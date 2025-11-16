import express from "express";
import mongoose from "mongoose";
import { createServer } from "http";
import { Server } from "socket.io";
import cors from "cors";
import route from "./route.js";

const app = express();
const port = 5000;
const dburl = "mongodb://localhost:27017/idocs";

const server = createServer(app);

const io = new Server(server, {
  cors: {
    origin: "*",
    methods: ["GET", "POST"],
  },
});

app.use(cors({
  origin: "*",
  methods: ["GET", "POST", "PUT", "DELETE", "PATCH"],
  credentials: true
}));

app.use(express.json());
app.use(express.urlencoded({ extended: true }));

let users = 0;
let currentText = "";

io.on("connection", (socket) => {
  users++;
  console.log(`New User connected. Users online: ${users}`);

  io.emit("user-count", users);

  socket.emit("init-text", currentText);

  socket.on("text-update", (data) => {
    const { text } = data;

    currentText = text;
    socket.broadcast.emit("text-change", {
      text: text,
      userId: socket.id,
    });

    console.log('Text updated');
  });

  socket.on("disconnect", () => {
    users--;
    console.log(`User disconnected. Users online: ${users}`);

    io.emit("user-count", users);
  });
});

mongoose
  .connect(dburl)
  .then(() => {
    console.log("Database connected successfully");
    server.listen(port, () => console.log(`App listening on port ${port}!`));
  })
  .catch((err) => console.log(err));

app.use("/api", route);