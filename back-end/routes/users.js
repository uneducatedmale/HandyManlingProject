const express = require('express');
const router = express.Router();
const { User, validateUser } = require('../models/user');
const auth = require('../middleware/auth');
const bcrypt = require('bcrypt');
const Joi = require('joi');
const _ = require('lodash');

// Create account
router.post('/create-account', async (req, res) => {
    try {
        const { error } = validateUser(req.body);
        if (error) return res.status(400).send(error.details[0].message);

        let user = await User.findOne({ email: req.body.email });
        if (user) return res.status(400).send('A user with this email already exists');

        user = new User(_.pick(req.body, ['firstName', 'lastName', 'email', 'password']));
        const salt = await bcrypt.genSalt(10);
        user.password = await bcrypt.hash(user.password, salt);
        await user.save();

        res.send('success');
    } catch (err) {
        console.error('Error creating account:', err.message);
        res.status(500).send('An error occurred while creating the account');
    }
});

// Sign in
function validateSignIn(credentials) {
    const schema = Joi.object({
        email: Joi.string().email().required(),
        password: Joi.string().required(),
    });
    return schema.validate(credentials);
}

router.post('/sign-in', async (req, res) => {
    try {
        const { error } = validateSignIn(req.body);
        if (error) return res.status(400).send(error.details[0].message);

        const user = await User.findOne({ email: req.body.email });
        if (!user) return res.status(400).send('Invalid email or password');

        const validPassword = await bcrypt.compare(req.body.password, user.password);
        if (!validPassword) return res.status(400).send('Invalid email or password');

        const token = user.generateAuthToken();
        res.send({
            token,
            email: user.email,
            projects: user.projects,
        });
    } catch (err) {
        console.error('Error signing in:', err.message);
        res.status(500).send('An error occurred while signing in');
    }
});

// Add project
function validateProject(body) {
    const schema = Joi.object({
        name: Joi.string().required(),
        memo: Joi.string().required(),
    });
    return schema.validate(body);
}

router.post('/add-project', auth, async (req, res) => {
    try {
        const { error } = validateProject(req.body);
        if (error) return res.status(400).send('Invalid add-project request: ' + error.details[0].message);

        const user = await User.findById(req.user._id);
        if (!user) return res.status(401).send('Not authorized to perform this function');

        const newProject = {
            name: req.body.name,
            memo: req.body.memo,
            materials: [],
            laborers: [],
            jobPay: 0,
            timeStamp: new Date().toISOString(), // Set timestamp only during creation
        };

        user.projects.push(newProject);
        await user.save();
        res.send(user.projects);
    } catch (err) {
        console.error('Error adding project:', err.message);
        res.status(500).send('An error occurred while adding the project');
    }
});




// Edit memo route
function validateEditMemo(body) {
    const schema = Joi.object({
        index: Joi.number().integer().min(0).required(),
        name: Joi.string().required(),
        memo: Joi.string().required(),
    });
    return schema.validate(body);
}

router.post('/edit-project', auth, async (req, res) => {
    try {
        const { error } = validateEditProject(req.body);
        if (error) return res.status(400).send('Invalid edit-project request: ' + error.details[0].message);

        const user = await User.findById(req.user._id);
        if (!user) return res.status(401).send('Not authorized to perform this function');

        const project = user.projects.id(req.body.projectId);
        if (!project) return res.status(404).send('Project not found');

        // Update only the fields that should be editable
        project.name = req.body.name;
        project.memo = req.body.memo;
        // Do not update timeStamp here

        await user.save();
        res.send(user.projects);
    } catch (err) {
        console.error('Error editing project:', err.message);
        res.status(500).send('An error occurred while editing the project');
    }
});

// Delete project
function validateDeleteProjectRequest(body) {
    const schema = Joi.object({
        index: Joi.number().integer().min(0).required(),
    });
    return schema.validate(body);
}

router.post('/delete-project', auth, async (req, res) => {
    try {
        const { error } = validateDeleteProjectRequest(req.body);
        if (error) return res.status(400).send('Invalid delete-project request');

        const user = await User.findById(req.user._id);
        if (!user) return res.status(401).send('Not authorized to perform this function');

        if (req.body.index >= user.projects.length) {
            return res.status(400).send('Invalid project index');
        }

        user.projects.splice(req.body.index, 1);
        await user.save();

        res.send(user.projects);
    } catch (err) {
        console.error('Error deleting project:', err.message);
        res.status(500).send('An error occurred while deleting the project');
    }
});


// Add material
function validateMaterial(body) {
    const schema = Joi.object({
        projectId: Joi.string().required(),
        name: Joi.string().required(),
        quantity: Joi.number().required(),
        value: Joi.number().required(),
    });
    return schema.validate(body);
}

router.post('/add-material', auth, async (req, res) => {
    try {
        const { error } = validateMaterial(req.body);
        if (error) return res.status(400).send('Invalid add-material request: ' + error.details[0].message);

        const user = await User.findById(req.user._id);
        if (!user) return res.status(401).send('Not authorized to perform this function');

        const project = user.projects.id(req.body.projectId);
        if (!project) return res.status(404).send('Project not found');

        project.materials.push({
            name: req.body.name,
            quantity: req.body.quantity,
            value: req.body.value,
        });

        await user.save();
        res.send(user.projects);
    } catch (err) {
        console.error('Error adding material:', err.message);
        res.status(500).send('An error occurred while adding the material');
    }
});

// Delete material
function validateDeleteMaterial(body) {
    const schema = Joi.object({
        projectId: Joi.string().required(),
        materialId: Joi.string().required(),
    });
    return schema.validate(body);
}

router.post('/delete-material', auth, async (req, res) => {
    try {
        const { error } = validateDeleteMaterial(req.body);
        if (error) return res.status(400).send('Invalid delete-material request: ' + error.details[0].message);

        const user = await User.findById(req.user._id);
        if (!user) return res.status(401).send('Not authorized to perform this function');

        const project = user.projects.id(req.body.projectId);
        if (!project) return res.status(404).send('Project not found');

        const materialIndex = project.materials.findIndex(
            (material) => material._id.toString() === req.body.materialId
        );

        if (materialIndex === -1) return res.status(404).send('Material not found');

        project.materials.splice(materialIndex, 1); // Remove the material
        await user.save();
        res.send(user.projects);
    } catch (err) {
        console.error('Error removing material:', err.message);
        res.status(500).send('An error occurred while removing the material');
    }
});

// Edit material
function validateEditMaterial(body) {
    const schema = Joi.object({
        projectId: Joi.string().required(),
        materialId: Joi.string().required(),
        name: Joi.string().required(),
        quantity: Joi.number().required(),
        value: Joi.number().required(),
    });
    return schema.validate(body);
}

router.post('/edit-material', auth, async (req, res) => {
    try {
        const { error } = validateEditMaterial(req.body);
        if (error) return res.status(400).send('Invalid edit-material request: ' + error.details[0].message);

        const user = await User.findById(req.user._id);
        if (!user) return res.status(401).send('Not authorized to perform this function');

        const project = user.projects.id(req.body.projectId);
        if (!project) return res.status(404).send('Project not found');

        const material = project.materials.id(req.body.materialId);
        if (!material) return res.status(404).send('Material not found');

        material.name = req.body.name;
        material.quantity = req.body.quantity;
        material.value = req.body.value;

        await user.save();
        res.send(user.projects);
    } catch (err) {
        console.error('Error editing material:', err.message);
        res.status(500).send('An error occurred while editing the material');
    }
});

// Add laborer
function validateLaborer(body) {
    const schema = Joi.object({
        projectId: Joi.string().required(),
        name: Joi.string().required(),
        job: Joi.string().required(),
        hourlyWage: Joi.number().required(),
        hoursWorked: Joi.number().required(),
    });
    return schema.validate(body);
}

router.post('/add-laborer', auth, async (req, res) => {
    try {
        const { error } = validateLaborer(req.body);
        if (error) return res.status(400).send('Invalid add-laborer request: ' + error.details[0].message);

        const user = await User.findById(req.user._id);
        if (!user) return res.status(401).send('Not authorized to perform this function');

        const project = user.projects.id(req.body.projectId);
        if (!project) return res.status(404).send('Project not found');

        project.laborers.push({
            name: req.body.name,
            job: req.body.job,
            hourlyWage: req.body.hourlyWage,
            hoursWorked: req.body.hoursWorked,
        });

        await user.save();
        res.send(user.projects);
    } catch (err) {
        console.error('Error adding laborer:', err.message);
        res.status(500).send('An error occurred while adding the laborer');
    }
});

// Edit laborer validation
function validateEditLaborer(body) {
    const schema = Joi.object({
        projectId: Joi.string().required(), // Project ID is required
        laborerId: Joi.string().required(), // Laborer ID is required for identification
        name: Joi.string().required(), // Laborer's name is required
        job: Joi.string().required(), // Laborer's job is required
        hourlyWage: Joi.number().required(), // Laborer's hourly wage is required
        hoursWorked: Joi.number().required(), // Laborer's hours worked are required
    });
    return schema.validate(body);
}

// Edit laborer
router.post('/edit-laborer', auth, async (req, res) => {
    try {
        const { error } = validateEditLaborer(req.body); // Validate the incoming request
        if (error) return res.status(400).send('Invalid edit-laborer request: ' + error.details[0].message);

        const user = await User.findById(req.user._id);
        if (!user) return res.status(401).send('Not authorized to perform this function');

        const project = user.projects.id(req.body.projectId);
        if (!project) return res.status(404).send('Project not found');

        const laborer = project.laborers.id(req.body.laborerId);
        if (!laborer) return res.status(404).send('Laborer not found');

        // Update laborer details
        laborer.name = req.body.name;
        laborer.job = req.body.job;
        laborer.hourlyWage = req.body.hourlyWage;
        laborer.hoursWorked = req.body.hoursWorked;

        await user.save();
        res.send(user.projects);
    } catch (err) {
        console.error('Error editing laborer:', err.message);
        res.status(500).send('An error occurred while editing the laborer');
    }
});

// Delete laborer validation
function validateDeleteLaborer(body) {
    const schema = Joi.object({
        projectId: Joi.string().required(), // Project ID is required
        laborerId: Joi.string().required(), // Laborer ID is required
    });
    return schema.validate(body);
}

// Delete laborer
router.post('/delete-laborer', auth, async (req, res) => {
    try {
        const { error } = validateDeleteLaborer(req.body); // Validate the incoming request
        if (error) return res.status(400).send('Invalid delete-laborer request: ' + error.details[0].message);

        const user = await User.findById(req.user._id);
        if (!user) return res.status(401).send('Not authorized to perform this function');

        const project = user.projects.id(req.body.projectId);
        if (!project) return res.status(404).send('Project not found');

        const laborerIndex = project.laborers.findIndex(
            (laborer) => laborer._id.toString() === req.body.laborerId
        );

        if (laborerIndex === -1) return res.status(404).send('Laborer not found');

        project.laborers.splice(laborerIndex, 1); // Remove the laborer
        await user.save();
        res.send(user.projects);
    } catch (err) {
        console.error('Error removing laborer:', err.message);
        res.status(500).send('An error occurred while removing the laborer');
    }
});


// Update project pay
function validatePay(body) {
    const schema = Joi.object({
        projectId: Joi.string().required(),
        jobPay: Joi.number().required(),
    });
    return schema.validate(body);
}

router.post('/update-pay', auth, async (req, res) => {
    try {
        const { error } = validatePay(req.body);
        if (error) return res.status(400).send('Invalid update-pay request: ' + error.details[0].message);

        const user = await User.findById(req.user._id);
        if (!user) return res.status(401).send('Not authorized to perform this function');

        const project = user.projects.id(req.body.projectId);
        if (!project) return res.status(404).send('Project not found');

        project.jobPay = req.body.jobPay;
        await user.save();

        res.send(user.projects);
    } catch (err) {
        console.error('Error updating pay:', err.message);
        res.status(500).send('An error occurred while updating the pay');
    }
});



// Export
module.exports = router;
