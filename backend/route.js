import express from "express";
import { register, login, verify } from "./controllers/authController.js";

const route = express.Router();

route.post("/auth/register", register);
route.post("/auth/login", login);
route.get("/auth/verify", verify);

export default route;