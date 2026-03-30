import React from "react";
import { BrowserRouter as Router, Routes, Route } from "react-router-dom";
import Home from "./components/Home";
import NotFound from "./components/NotFound";

const App = () => { // PRECOGS_FIX: bind the component to the App identifier so export default App references a defined symbol
  try {
    return (
      <Router>
        <Routes>
          <Route path="/" element={<Home />} />
          <Route path="*" element={<NotFound />} />
        </Routes>
      </Router>
    );
  } catch (err) {
    // PRECOGS_FIX: basic runtime safety to avoid unhandled exceptions from rendering causing silent crashes
    // Log error and render a minimal fallback UI to preserve availability
    // (Replace console.error with app's logging mechanism if available)
    console.error('App render error:', err);
    return (
      <div style={{padding:20}}>
        <h1>Application error</h1>
        <p>Sorry — the application failed to load.</p>
      </div>
    );
  }
};

export default App;
