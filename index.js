const express = require("express");
const app = express();
app.use(express.json());
app.use(express.urlencoded({ extended: false }));
const mysql = require("mysql");
const PORT = process.env.PORT || 3000;
const cors = require("cors");
app.use(cors());

const connection = mysql.createConnection({
  host: "localhost",
  user: "root",
  password: "",
  database: "products",
});

connection.connect();

// GET ALL CATEGORIES

app.get("/api/category", (req, res) => {
  connection.query("SELECT * FROM category", (err, rows, fields) => {
    if (err) throw err;

    res.json(rows);
  });
});

// GET A SPECIFIC CATEGORY

app.get("/api/category/:category_id", (req, res) => {
  const category_id = req.params.category_id;

  connection.query(
    `SELECT * FROM category WHERE category_id='${category_id}'`,
    (err, rows, fields) => {
      if (err) throw err;

      res.json(rows);
    }
  );
});

// LIST ALL PRODUCTS IN A CERTAIN CATEGORY

app.get("/api/category/:category_id/products", (req, res) => {
  const category_id = req.params.category_id;

  connection.query(
    `SELECT * FROM product_info WHERE product_category='${category_id}'`,
    (err, rows, fields) => {
      if (err) throw err;

      res.json(rows);
    }
  );
});

// LIST A CERTAIN PRODUCT IN A CERTAIN CATEGORY

app.get("/api/category/:category_id/products/:product_id", (req, res) => {
  const category_id = req.params.category_id;
  const product_id = req.params.product_id;

  connection.query(`SELECT * FROM category`, (err, rows, fields) => {
    if (err) throw err;

    res.json(rows);
  });
});

// ============================ CATEGORY FUNCTIONS ============================

// CREATE A CATEGORY

app.post("/api/category", (req, res) => {
  const category_name = req.body.category_name;

  connection.query(
    `INSERT INTO category (category_id, category_name) VALUES (NULL,'${category_name}')`,

    (err, rows, fields) => {
      if (err) throw err;

      res.json({ msg: `Successfully Inserted!` });
    }
  );
});

// EDIT A CATEGORY

app.put("/api/category", (req, res) => {
  const category_id = req.body.category_id;
  const category_name = req.body.category_name;

  connection.query(
    `UPDATE category SET category_name='${category_name}' WHERE category_id='${category_id}'`,

    (err, rows, fields) => {
      if (err) throw err;

      res.json({ msg: `Successfully Updated!` });
    }
  );
});

// DELETE A CATEGORY

app.delete("/api/category", (req, res) => {
  const category_id = req.body.category_id;

  connection.query(
    `DELETE FROM category WHERE category_id='${category_id}'`,

    (err, rows, fields) => {
      if (err) throw err;

      res.json({ msg: `Successfully Deleted!` });
    }
  );
});

// CREATE A PRODUCT

app.post("/api/category/:category_id/products", (req, res) => {
  const product_category = req.params.category_id;
  const product_name = req.body.product_name;
  const product_price = req.body.product_price;

  connection.query(
    `INSERT INTO product_info (product_id,product_name, product_price, product_category) VALUES (NULL, '${product_name}','${product_price}', '${product_category}')`,

    (err, rows, fields) => {
      if (err) throw err;

      res.json({ msg: `Successfully Inserted!` });
    }
  );
});

// DELETE A PRODUCT

app.delete("/api/products", (req, res) => {
  // const product_category = req.params.category_id;
  const product_id = req.body.product_id;

  connection.query(
    `DELETE FROM product_info WHERE product_id = '${product_id}'`,

    (err, rows, fields) => {
      if (err) throw err;

      res.json({ msg: `Successfully Inserted!` });
    }
  );
});

app.listen(PORT, () => {
  console.log(`Server is running on port http://localhost:${PORT}`);
});
