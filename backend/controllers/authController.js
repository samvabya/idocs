import User from "../model.js";
import jwt from "jsonwebtoken";

const JWT_SECRET = process.env.JWT_SECRET || "sam-secret-01";
const JWT_EXPIRES_IN = "1h";

export const register = async (req, res) => {
  try {
    const { email, password } = req.body;

    if (!password || !email) {
      return res.status(400).json({ 
        message: "Email and Password are required" 
      });
    }

    const userExists = await User.exists({ email });
    if (userExists) {
      return res.status(400).json({ 
        message: "User already exists with this email" 
      });
    }

    const userData = new User({
      email,
      password
    });

    const savedUser = await userData.save();

    const token = jwt.sign(
      { id: savedUser._id, email: savedUser.email },
      JWT_SECRET,
      { expiresIn: JWT_EXPIRES_IN }
    );

    res.status(201).json({
      message: "User registered successfully",
      token,
      user: {
        id: savedUser._id,
        email: savedUser.email,
        password: savedUser.password
      }
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

export const login = async (req, res) => {
  try {
    const { email, password } = req.body;

    if (!email || !password) {
      return res.status(400).json({ 
        message: "Email and password are required" 
      });
    }

    const user = await User.findOne({ email });
    if (!user) {
      return res.status(401).json({ 
        message: "Invalid email or password" 
      });
    }

    if (password != user.password) {
      return res.status(401).json({ 
        message: "Invalid email or password" 
      });
    }

    const token = jwt.sign(
      { id: user._id, email: user.email },
      JWT_SECRET,
      { expiresIn: JWT_EXPIRES_IN }
    );

    res.status(200).json({
      message: "Login successful",
      token,
      user: {
        id: user._id,
        email: user.email,
        password: user.password
      }
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};



export const verify = async (req, res) => {
    try {
      const authHeader = req.headers.authorization;
      
      if (!authHeader || !authHeader.startsWith("Bearer ")) {
        return res.status(401).json({ 
          message: "Access denied. No token provided." 
        });
      }
  
      const token = authHeader.substring(7); // Remove 'Bearer ' prefix
  
      const decoded = jwt.verify(token, JWT_SECRET);
      
      req.user = decoded;
      const { email } = req.user;

      const user = await User.findOne({ email });

      res.status(200).json({ 
        message: "Token verified successfully",
        user: user
      });
    } catch (error) {
      if (error.name === "TokenExpiredError") {
        return res.status(401).json({ 
          message: "Token expired. Please login again." 
        });
      }
      if (error.name === "JsonWebTokenError") {
        return res.status(401).json({ 
          message: "Invalid token." 
        });
      }
      res.status(500).json({ message: error.message });
    }
  };