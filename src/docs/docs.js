// const 
/**
 * @openapi
 * /api/1.0/persons:
 *   get:
 *     tags:
 *       - persons
 *     responses:
 *       200:
 *         description: OK
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 status:
 *                   type: string
 *                   example: OK
 *                 data:
 *                   type: array 
 *                   items: 
 *                     $ref: "#/components/schemas/persons"
 */
